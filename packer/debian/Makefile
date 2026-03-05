SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := debian

RELEASE  := trixie
VERSION  := 20260220-2394
ARTIFACT := debian-13-generic-amd64-$(VERSION).qcow2
CHECKSUM := 8e7becf9843224e31a271df5eb6aa90a8077642786996f88f299d4f16043c9bfc563a74437ebfe17990c58362176c309cc61c6f09a83f1c274d799dd02997d4d

#RELEASE  := bookworm
#VERSION  := 20260129-2372
#ARTIFACT := debian-12-generic-amd64-$(VERSION).qcow2
#CHECKSUM := bb0fbc6fb36e5a4c5c1e003c2e9d2ef40981944a97889ea179c13f1d06be44971c9aa66c2f3788822367bed0175685697e4d9b8c9fe04c83b13ac014c02c19b6

CPUS      ?= 1
MEMORY    ?= 2048
DISK_SIZE ?= 10240

PACKER             := $(SELF)/../../bin/packer
PACKER_PLUGIN_PATH := $(SELF)/../../bin
PACKER_LOG         ?= 1
HEADLESS           ?= true

define CLOUD_CONFIG_YML
#cloud-config
users:
- name: debian
  plain_text_passwd: asd
  lock_passwd: false
  sudo: ALL=(ALL) NOPASSWD:ALL
  shell: /bin/bash
ssh_pwauth: true
endef

define PACKERFILE_HCL
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = true
  iso_url      = "https://cloud.debian.org/images/cloud/$(RELEASE)/$(VERSION)/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  qemuargs = [
    ["-cpu", "host"],
    ["-smp", "cpus=$(CPUS)"],
    ["-cdrom", "$(SELF)/.cache/$(ARTIFACT).iso"],
    ["-serial", "stdio"],
  ]

  ssh_username = "debian"
  ssh_password = "asd"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "shell" {
    execute_command = "sudo {{.Vars}} bash {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/02-kernel.sh",
      "remote-exec/98-apparmor.sh",
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
