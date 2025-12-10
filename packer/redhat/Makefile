SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := redhat

# https://access.redhat.com/management/systems
include $(SELF)/subscription.mk

# https://access.redhat.com/downloads/content/479/ver=/rhel---10/10.1/x86_64/product-software
RELEASE  := 10
VERSION  := $(RELEASE).1
ARTIFACT := rhel-$(VERSION)-x86_64-kvm.qcow2
CHECKSUM := dc74ad1a9ccd3c62a02cc29f7f4715e47fa0fdaf08a8080dd20906f885f29bae

# https://access.redhat.com/downloads/content/479/ver=/rhel---9/9.3/x86_64/product-software
#RELEASE  := 9
#VERSION  := $(RELEASE).3
#ARTIFACT := rhel-$(VERSION)-x86_64-kvm.qcow2
#CHECKSUM := fafa0b90267206cb5c7d41fcadea245918ae7aca9997b87397d845e63bdabeec

## https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.6/x86_64/product-software
#RELEASE  := 8
#VERSION  := $(RELEASE).6
#ARTIFACT := rhel-$(VERSION)-x86_64-kvm.qcow2
#CHECKSUM := c9b32bef88d605d754b932aad0140e1955ab9446818c70c4c36ca75d6f442fe9

CPUS      ?= 2
MEMORY    ?= 2048
DISK_SIZE ?= 12288

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
users:
- name: cloud-user
  plain_text_passwd: asd
  lock_passwd: false
  sudo: ALL=(ALL) NOPASSWD:ALL
ssh_pwauth: true
endef

define PACKERFILE
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

  ssh_username = "cloud-user"
  ssh_password = "asd"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "shell" {
    environment_vars = [
      "SUBSCRIPTION_USERNAME=$(SUBSCRIPTION_USERNAME)",
      "SUBSCRIPTION_PASSWORD=$(SUBSCRIPTION_PASSWORD)",
      "RELEASE=$(RELEASE)",
    ]
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
