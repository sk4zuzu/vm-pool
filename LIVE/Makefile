SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

.PHONY: all

all:

.PHONY: purge

purge:
	-find $(SELF)/ -type d -name .terragrunt-cache   -print0 | xargs -0 --no-run-if-empty rm -rf
	-find $(SELF)/ -type f -name .terraform.lock.hcl -print0 | xargs -0 --no-run-if-empty rm -f
