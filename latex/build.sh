#!/bin/bash

cd "/source"
find . -mindepth 1 -type d ! -path "./.git/*" -exec mkdir -p "/build/{}" \;
latexmk --output-directory=/build -f -pdf ${NAME}.tex
echo "INFO latexmk returned $?"

cd "/"
find "/build" -type f -name "*.pdf" -exec cp -v "{}" "/result/" \;

if [ "$DEBUG" = "1" ]; then
	cd "/build"
	exec /bin/bash
fi
