SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := alpine

RELEASE  := 3.14
ARTIFACT := alpine-virt-$(RELEASE).2-x86_64.iso

CHECKSUM := fcba6ecc8419da955d326a12b2f6d9d8f885a420a1112e0cf1910914c4c814a7

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 10240

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = false
  iso_url      = "https://dl-cdn.alpinelinux.org/alpine/v$(RELEASE)/releases/x86_64/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  net_device     = "virtio-net"
  disk_interface = "virtio"

  communicator     = "none"
  shutdown_command = "echo packer | sudo -S shutdown -P now"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)

  boot_wait = "10s"

  boot_command = [
    "root<enter><wait1s>",

    "set -o pipefail<enter>",

    "setup-keymap us us<enter>",
    "setup-hostname alpine<enter>",

    "cat >/etc/network/interfaces <<EOF<enter>",
    "auto lo<enter>",
    "iface lo inet loopback<enter>",
    "auto eth0<enter>",
    "iface eth0 inet dhcp<enter>",
    "EOF<enter>",

    "cat >/etc/resolv.conf <<EOF<enter>",
    "nameserver 8.8.8.8<enter>",
    "EOF<enter>",

    "rc-service networking start<enter>",
    "rc-update add networking boot<enter>",

    "setup-timezone<enter>",
    "UTC<enter>",

    "cat >/etc/apk/repositories <<EOF<enter>",
    "http://dl-cdn.alpinelinux.org/alpine/v$(RELEASE)/main<enter>",
    "http://dl-cdn.alpinelinux.org/alpine/v$(RELEASE)/community<enter>",
    "EOF<enter>",

    "apk --no-cache add dropbear openssh-client<enter>",
    "rc-service dropbear start<enter>",
    "rc-update add dropbear<enter>",

    "apk --no-cache add openntpd<enter>",
    "rc-service openntpd start<enter>",
    "rc-update add openntpd<enter>",

    "apk --no-cache add util-linux cloud-init<enter>",
    "setup-cloud-init<enter>",

    "yes | setup-disk -m sys /dev/vda<enter>",

    "sync<enter>",
    "poweroff<enter>",
  ]
}
build {
  sources = ["source.qemu.$(NAME)"]
}
endef

export

.PHONY: all

all: build

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: Makefile
	mkdir -p $(SELF)/.cache/
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/