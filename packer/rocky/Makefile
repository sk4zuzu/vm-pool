SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := rocky

RELEASE  := 10
VERSION  := $(RELEASE).1-20251116.0
ARTIFACT := Rocky-$(RELEASE)-GenericCloud-Base-$(VERSION).x86_64.qcow2
CHECKSUM := 28628abf08a134c6f9e1eccbcac3f2898715919a6da294ae2c6cd66d6bc347ad

CPUS      ?= 1
MEMORY    ?= 2048
DISK_SIZE ?= 12288

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
users:
- name: rocky
  plain_text_passwd: asd
  lock_passwd: false
  sudo: ALL=(ALL) NOPASSWD:ALL
ssh_pwauth: true
endef

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = true
  iso_url      = "https://dl.rockylinux.org/pub/rocky/$(RELEASE)/images/x86_64/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  qemuargs = [
    ["-cpu", "host"],
    ["-cdrom", "$(SELF)/.cache/$(ARTIFACT).iso"],
    ["-serial", "stdio"],
  ]

  ssh_username = "rocky"
  ssh_password = "asd"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "shell" {
    expect_disconnect = true
    execute_command   = "sudo {{.Vars}} bash {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/02-kernel.sh",
      "remote-exec/98-selinux.sh",
      "remote-exec/99-fixes.sh",
    ]
  }
}
endef

export

.PHONY: all

all: build

$(SELF)/.cache/cloud-config.yml:
	install -d $(SELF)/.cache/ && echo "$$CLOUD_CONFIG" >$@

$(SELF)/.cache/$(ARTIFACT).iso: $(SELF)/.cache/cloud-config.yml
	cloud-localds $@ $^

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: $(SELF)/.cache/$(ARTIFACT).iso Makefile $(wildcard $(SELF)/remote-exec/*.sh)
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
