SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := alma_9p

RELEASE  := 9
VERSION  := $(RELEASE).4-20240507
ARTIFACT := AlmaLinux-$(RELEASE)-GenericCloud-$(VERSION).x86_64.qcow2
CHECKSUM := bff0885c804c01fff8aac4b70c9ca4f04e8c119f9ee102043838f33e06f58390

#RELEASE  := 8
#VERSION  := $(RELEASE).10-20240530
#ARTIFACT := AlmaLinux-$(RELEASE)-GenericCloud-$(VERSION).x86_64.qcow2
#CHECKSUM := 41a6bcdefb35afbd2819f0e6c68005cd5e9a346adf2dc093b1116a2b7c647d86

CPUS       ?= 4
MEMORY     ?= 12288
DISK1_SIZE ?= 12G
DISK2_SIZE ?= 48G

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
ssh_pwauth: true
password: asd
chpasswd:
  expire: false
endef

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = true
  iso_url      = "https://repo.almalinux.org/almalinux/$(RELEASE)/cloud/x86_64/images/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory               = "$(MEMORY)"
  disk_size            = "$(DISK1_SIZE)"
  disk_additional_size = ["$(DISK2_SIZE)"] # needed to re-build the kernel

  qemuargs = [
    ["-cpu", "host"],
    ["-smp", "cpus=$(CPUS)"],
    ["-cdrom", "$(SELF)/.cache/$(ARTIFACT).iso"],
    ["-serial", "stdio"],
  ]

  ssh_username = "almalinux"
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
      "remote-exec/03-selinux.sh",
      "remote-exec/04-libvirt.sh",
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
