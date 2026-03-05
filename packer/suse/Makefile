SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := suse

# https://scc.suse.com/products/2930
include $(SELF)/subscription.mk

VERSION  := 16.0
ARTIFACT := SLES-$(VERSION)-Minimal-VM.x86_64-Cloud-QU0.qcow2
CHECKSUM := e7a47534915e97bdea596eb5c84558c7ea268653f034ae8283967328b382114b

CPUS      ?= 1
MEMORY    ?= 2048
DISK_SIZE ?= 12288

PACKER             := $(SELF)/../../bin/packer
PACKER_PLUGIN_PATH := $(SELF)/../../bin
PACKER_LOG         ?= 1
HEADLESS           ?= true

define CLOUD_CONFIG_YML
#cloud-config
users:
- name: suse
  plain_text_passwd: asd
  lock_passwd: false
  sudo: ALL=(ALL) NOPASSWD:ALL
ssh_pwauth: true
endef

define PACKERFILE_HCL
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = true
  iso_url      = "file://$(SELF)/../../files/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  qemuargs = [
    ["-cpu", "host"],
    ["-smp", "cpus=$(CPUS)"],
    ["-cdrom", "$(SELF)/.cache/$(ARTIFACT).iso"],
    ["-serial", "stdio"],
  ]

  ssh_username = "suse"
  ssh_password = "asd"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "shell" {
    environment_vars = [
      "REGISTRATION_CODE=$(REGISTRATION_CODE)",
      "VERSION=$(VERSION)",
    ]
    expect_disconnect = true
    execute_command   = "sudo {{.Vars}} bash {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/02-kernel.sh",
      "remote-exec/99-fixes.sh",
    ]
  }
}
endef

export

.PHONY: all

all: build

$(SELF)/.cache/cloud-config.yml:
	install -d $(SELF)/.cache/ && echo "$$CLOUD_CONFIG_YML" >$@

$(SELF)/.cache/$(ARTIFACT).iso: $(SELF)/.cache/cloud-config.yml
	cloud-localds $@ $^

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: $(SELF)/.cache/$(ARTIFACT).iso Makefile $(wildcard $(SELF)/remote-exec/*.sh)
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE_HCL"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
