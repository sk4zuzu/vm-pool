SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

export

.PHONY: all

all: build

.PHONY: build build-k3s

build: build-k3s

build-k3s:
	cd $(SELF)/k3s/ && make build

.PHONY: clean clean-k3s

clean: clean-k3s

clean-k3s:
	cd $(SELF)/k3s/ && make clean
