#!/bin/bash

_info() {
	echo "INFO: $@" >&2
}

_error() {
	echo "ERROR: $@" >&2
}

_cancel_loop() {
	echo ""
	echo "Cancelled" >&2
	exit 0
}

_create_images() {
	pushd "/source" || { _error "Failed to switch to /source"; return 1; }
	# Create all images
	find . -mindepth 1 -name "*.uxf" -type f -exec /bin/bash -c 'mkdir -p "$(dirname "/images/$1")"' _ {} \;
	find . -mindepth 1 -name "*.uxf" -type f -exec /bin/bash -c 'java -jar /usr/bin/umlet -action=convert -format=pdf -filename="/source/${1}" -output="/images/${1%.uxf}.pdf"' _ {} \;
	popd

	return 0
}

_update_latex() {
	# Create empty directories for latexmk
	pushd "/source" || { _error "Failed to switch to /source"; return 1; }
	find . -mindepth 1 -type d ! -path "./.git/*" -exec mkdir -p "/build/{}" \;

	latexmk --output-directory=/build -f -pdf ${NAME}.tex
	_info "latexmk returned $?"
	popd

	return 0
}

_copy_result() {
	# Copy resulting PDF
	cd "/"
	find "/build" -maxdepth 1 -type f -name "*.pdf" -exec cp -v "{}" "/result/" \;
}

_loop_main() {
	local timeout="$((5 * 60))"
	local wlist="/tmp/watch-list"
	local changed=""
	local ret=0

	_info "Initial build ..."
	_create_images
	_update_latex
	_copy_result

	trap _cancel_loop 2
	while true; do
		local updateTex=0
		local updateUxf=0


		# Create list of watched files
		find "/source" -type f \( -name "*.tex" -o -name "*.uxf" \) > "$wlist"

		changed="$(inotifywait --timeout "$timeout" --format="%w" -e modify --fromfile "$wlist")"
		ret=$?

		if [ $ret -eq 0 ]; then
			case "${changed##*.}" in
			tex)
				updateTex=1
				;;
			uxf)
				updateUxf=1
				updateTex=1
				;;
			esac
		fi

		if [ $updateUxf -eq 1 ]; then
			_info "Regenerate Umlet files ..."
			_create_images
		fi

		if [ $updateTex -eq 1 ]; then
			_info "Update latex files ..."
			_update_latex
			_copy_result
		fi
	done
}

_main() {
	_create_images
	_update_latex
	_copy_result

	if [ "$DEBUG" = "1" ]; then
		cd "/build"
		exec /bin/bash
	fi
}

if [ "$(id -u)" = "${UID}" ] && [ "$(id -g)" = "${GID}" ]; then
	if [ "${LOOP:=0}" = "1" ]; then
		_loop_main $@
	else
		_main $@
	fi
else
	id -g ${USER} >/dev/null 2>/dev/null
	if [ $? -ne 0 ]; then
		groupadd -g ${GID} ${USER} || exit 1
	fi
	id -u ${USER} >/dev/null 2>/dev/null
	if [ $? -ne 0 ]; then
		useradd -g ${GID} -u ${UID} -m -s /bin/bash ${USER} || exit 1
	fi

	exec su-exec ${USER} /bin/bash /build.sh
fi
