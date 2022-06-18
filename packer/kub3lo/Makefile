SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

export

.PHONY: all

all: build

.PHONY: build build-k3s build-rke2

build: build-k3s build-rke2

build-k3s:
	cd $(SELF)/k3s/ && make build

build-rke2:
	cd $(SELF)/rke2/ && make build

.PHONY: clean clean-k3s clean-rke2

clean: clean-k3s clean-rke2

clean-k3s:
	cd $(SELF)/k3s/ && make clean

clean-rke2:
	cd $(SELF)/rke2/ && make clean
