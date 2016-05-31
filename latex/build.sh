#!/bin/bash

groupadd -g ${GID} ${USER}
useradd -g ${GID} -u ${UID} -M -s /bin/bash ${USER} || exit 1

cd "/source"
find . -mindepth 1 -type d ! -path "./.git/*" -exec mkdir -p "/build/{}" \;
find . -mindepth 1 -name "*.uxf" -type f -exec /bin/bash -c 'java -jar /usr/bin/umlet -action=convert -format=pdf -filename="/source/${1}" -output="/build${1%.uxf}.pdf"' _ {} \;
latexmk --output-directory=/build -f -pdf ${NAME}.tex
echo "INFO latexmk returned $?"

cd "/"
find "/build" -type f -name "*.pdf" -exec cp -v "{}" "/result/" \;

if [ "$DEBUG" = "1" ]; then
	cd "/build"
	exec /bin/bash
fi
