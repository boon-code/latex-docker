#!/bin/bash

_main() {
	cd "/source"
	# Create all images
	find . -mindepth 1 -name "*.uxf" -type f -exec /bin/bash -c 'mkdir -p "$(dirname "/images/$1")"' _ {} \;
	find . -mindepth 1 -name "*.uxf" -type f -exec /bin/bash -c 'java -jar /usr/bin/umlet -action=convert -format=pdf -filename="/source/${1}" -output="/images/${1%.uxf}.pdf"' _ {} \;

	# Create empty directories for latexmk
	find . -mindepth 1 -type d ! -path "./.git/*" -exec mkdir -p "/build/{}" \;

	latexmk --output-directory=/build -f -pdf ${NAME}.tex
	echo "INFO latexmk returned $?"

	# Copy resulting PDF
	cd "/"
	find "/build" -maxdepth 1 -type f -name "*.pdf" -exec cp -v "{}" "/result/" \;

	if [ "$DEBUG" = "1" ]; then
		cd "/build"
		exec /bin/bash
	fi
}

if [ "$(id -u)" = "${UID}" ] && [ "$(id -g)" = "${GID}" ]; then
	_main $@
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
