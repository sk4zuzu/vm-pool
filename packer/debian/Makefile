SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := debian

RELEASE  := bookworm
VERSION  := 20230531-1397
ARTIFACT := debian-12-generic-amd64-$(VERSION).qcow2
CHECKSUM := 84123ea7225934fe157535d7587498fdd2838299d3b57c76d8eac4e59faafb028b9b68ceadeddcccdc8c1586bf978a7d93e5c65142fb9de67d375b37945657d0

CPUS      ?= 1
MEMORY    ?= 2048
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
endef

define PACKERFILE
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
    execute_command = "sudo -iu root {{.Vars}} bash {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/02-kernel.sh",
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
