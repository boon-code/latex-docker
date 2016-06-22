Latex Compiler Container
========================

Simple Docker container to compile latex documents within some root directory.

## Structure

Paths:

- `/source`: Mount your the top-level folder of your latex project here
- `/images`: *Umlet* drawings will be placed in this folder
- `/build/`: Use a `tmpfs` for this folder
- `/result/`: PDF files will be copied here


Environemnt variables:

- `NAME`: Name of your top-level `*.tex` file (usually within your top-level
  project directory; if not, you can add subdirectories
- `LOOP`: Continuously rebuild document on change if set to `1` (default: `0`).
- `UID`: User ID of the current user (outside of docker container)
- `GID`: Group ID of the current user (outside of docker container)

## Example

To compile `Toplevel.tex` within your top-level directory and put the final
result into your top-level directory you have to run the following command:

        docker run --rm \
            -v "$(pwd):/source:ro" \
            -v "$(pwd):/result:rw" \
            -v "$(pwd)/img:/images:rw" \
            --tmpfs "/build" \
            --tmpfs "/tmp" \
            --tmpfs "/run"  \
            -e UID="$(id -u)" \
            -e GID="$(id -g)" \
            -e NAME=Toplevel \
            mhb/latex:latest

To contiunously rebuild your document you can set `LOOP=1`. In this mode,
*inotify* will be used to watch all `*.tex`, `*.bib` and `*.uxf` files. On
change, your document will be rebuild automatically.

        docker run --rm \
            -v "$(pwd):/source:ro" \
            -v "$(pwd):/result:rw" \
            -v "$(pwd)/img:/images:rw" \
            --tmpfs "/build" \
            --tmpfs "/tmp" \
            --tmpfs "/run"  \
            -e UID="$(id -u)" \
            -e GID="$(id -g)" \
            -e NAME=Toplevel \
            -e LOOP=1 \
            mhb/latex:latest


## Todo

- EPS to PDF (`find . -name "*.eps" -exec epstopdf {} \;`)
