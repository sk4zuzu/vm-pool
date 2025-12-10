SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := void

RELEASE  := musl-20250202
ARTIFACT := void-live-x86_64-$(RELEASE)-base.iso
CHECKSUM := 0c46bf13a7a019c1fec0b2969201aecf09ff9a7646ef749e04ea63ead0c86404

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
  iso_url      = "https://repo-default.voidlinux.org/live/current/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  net_device     = "virtio-net"
  disk_interface = "virtio"

  qemuargs = [
    ["-cpu", "host"],
    ["-smp", "cpus=$(CPUS)"],
    ["-serial", "stdio"],
  ]

  ssh_username     = "anon"
  ssh_password     = "voidlinux"
  shutdown_command = "sudo /sbin/poweroff"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)

  http_directory = "$(SELF)/remote-exec/"

  boot_wait    = "8s"
  boot_command = ["<enter>"]
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "file" {
    source      = "remote-exec/00-shinit.sh"
    destination = "/tmp/00-shinit.sh"
  }
  provisioner "shell" {
    execute_command = "sudo --login {{.Vars}} bash {{.Path}}"
    scripts = [
      "remote-exec/01-bootstrap.sh",
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
