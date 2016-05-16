Latex Compiler Container
========================

This shall become a simple command-line latex compiler.

Simple Docker container to compile latex documents within some root directory.

## Structure

Paths:
- `/source`: Mount your the top-level folder of your latex project here
- `/build/`: Use a `tmpfs` for this folder
- `/result/`: PDF files will be copied here

Environemnt variables:
- `NAME`: Name of your top-level `*.tex` file (usually within your top-level project
          directory; if not, you can add subdirectories

## Example

To compile `Toplevel.tex` within your top-level directory and put the final result into
your top-level directory you have to run the following command:

`docker run --rm -v "$(pwd):/source:ro" -v "$(pwd):/result:rw" --tmpfs "/build" --user "$(id -u):$(id -g)" -e NAME=Toplevel mhb/latex:latest`

## Todo

- EPS to PDF (`find . -name "*.eps" -exec epstopdf {} \;`)
