SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := alpine

RELEASE  := 3.20
VERSION  := $(RELEASE).3
ARTIFACT := nocloud_alpine-$(VERSION)-x86_64-bios-cloudinit-r0.qcow2
CHECKSUM := 73bd1fdfd9a0b4db250c923630a415a054ed1ae869e6ff4a121b49d28b2fb3a2a21a948bd0c121e5640f3f16c68cfb574b72fd6a4395a788a71f7f279c1c52e3

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 10240

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
password: asd
ssh_pwauth: true
chpasswd:
  expire: false
packages: [bash, sudo]
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
    execute_command = "sudo -iu root {{.Vars}} bash {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
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
