
.PHONY:
all: info

.PHONY:
info:
	@echo "build ... Build latex Docker image"

.PHONY:
build:
	cd latex; docker build -t mhb/latex:latest .
