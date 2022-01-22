SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := centos

VERSION  := 7.5
ARTIFACT := CentOS-7-x86_64-GenericCloud-1804_02.qcow2
CHECKSUM := d7d720e4c2970a4dade749bf504bf8afe8b638a30c614efc43a6c769c1b5bc46

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 12288

PACKER     := $(SELF)/../../bin/packer
PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
ssh_pwauth: true
password: centos
chpasswd:
  expire: false
endef

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = true
  iso_url      = "https://cloud.centos.org/centos/7/images/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  qemuargs = [
    ["-fda", "$(SELF)/.cache/$(ARTIFACT).iso"],
  ]

  ssh_username = "centos"
  ssh_password = "centos"

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
      "remote-exec/02-selinux.sh",
      "remote-exec/03-systemd.sh",
    ]
  }
}
endef

export

.PHONY: all

all: build

$(SELF)/.cache/cloud-config.yml:
	mkdir -p $(SELF)/.cache/ && echo "$$CLOUD_CONFIG" >$@

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
