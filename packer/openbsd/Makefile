SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := openbsd

RELEASE  := 7.4
VERSION  := $(RELEASE)
ARTIFACT := install74.iso
CHECKSUM := a1001736ed9fe2307965b5fcdb426ae11f9b80d26eb21e404a705144a0a224a0

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 12288

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = false
  iso_url      = "https://cdn.openbsd.org/pub/OpenBSD/$(VERSION)/amd64/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  net_device     = "virtio-net"
  disk_interface = "virtio"

  qemuargs = [
    ["-serial", "stdio"],
  ]

  ssh_username     = "root"
  ssh_password     = "asd"
  shutdown_command = "/sbin/halt -p"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)

  http_directory = "$(SELF)/remote-exec/"
  http_port_min  = 8686
  http_port_max  = 8686

  boot_wait = "20s"

  boot_command = [
    "A<enter><wait1s>",
    "http://{{.HTTPIP}}:{{.HTTPPort}}/00-responses.txt<enter><wait1s>",
    "I<enter><wait1s>",
  ]
}
build {
  sources = [ "source.qemu.$(NAME)" ]
  provisioner "shell" {
    execute_command = "env {{.Vars}} ksh -l {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/02-cloud-init.sh",
      "remote-exec/99-fixes.sh",
    ]
  }
}
endef

export

.PHONY: all

all: build

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: Makefile $(wildcard $(SELF)/remote-exec/*.sh)
	mkdir -p $(SELF)/.cache/
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
