Latex Compiler Container
========================

This shall become a simple command-line latex compiler.

1. Copy original data from read-only volume-mount to container filesystem
2. Compile latex documents
3. Copy actual output to writable volume-mount
4. Drop to bash in case of errors (interactive-mode?)
