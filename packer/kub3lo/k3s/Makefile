SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := kub3lo

RELEASE  := 3.22
VERSION  := $(RELEASE).2
ARTIFACT := nocloud_alpine-$(VERSION)-x86_64-bios-cloudinit-r0.qcow2
CHECKSUM := 792948e73c48309d6517be9fd84fb6191b7e6cda04116ca55cfdddb49b2a491b009b0e7a9c5aedf0f854fe20675f737e85f5b8fc4dd1d69595fc80a0b19e744e

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 10240

PACKER     := $(SELF)/../../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
users:
# using the 'default' option here seemed to be breaking /etc/doas.conf
- name: alpine
  groups: [wheel] # relying here on default alpine/doas settings
  plain_text_passwd: asd
  lock_passwd: false
  sudo: ALL=(ALL) NOPASSWD:ALL
ssh_pwauth: true
endef

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = true
  iso_url      = "https://dl-cdn.alpinelinux.org/alpine/v$(RELEASE)/releases/cloud/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  net_device     = "virtio-net"
  disk_interface = "virtio"

  qemuargs = [
    ["-cpu", "host"],
    ["-smp", "cpus=$(CPUS)"],
    ["-cdrom", "$(SELF)/.cache/$(ARTIFACT).iso"],
    ["-serial", "stdio"],
  ]

  ssh_username = "alpine"
  ssh_password = "asd"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "shell" {
    execute_command = "doas /bin/ash {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/02-kernel.sh",
      "remote-exec/03-extras.sh",
      "remote-exec/51-k3s.sh",
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
