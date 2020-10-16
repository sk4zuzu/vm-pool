SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := centos

VERSION  := 7.8
ARTIFACT := CentOS-7-x86_64-GenericCloud-2003.qcow2
CHECKSUM := 1db30c9c272fb37b00111b93dcebff16c278384755bdbe158559e9c240b73b80

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 12288

PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
ssh_pwauth: true
password: centos
chpasswd:
  expire: false
endef

define Packerfile
{
  "builders": [
    {
      "type": "qemu",
      "accelerator": "kvm",

      "disk_image": "true",
      "iso_url": "https://cloud.centos.org/altarch/7/images/$(ARTIFACT)",
      "iso_checksum": "$(CHECKSUM)",

      "disk_size": "$(DISK_SIZE)",

      "qemuargs": [
        ["-fda", "$(SELF)/.cache/$(ARTIFACT).iso"]
      ],

      "ssh_username": "centos",
      "ssh_password": "centos",

      "output_directory": "$(SELF)/.cache/output/",
      "vm_name": "packer-$(NAME).qcow2",

      "headless": $(HEADLESS)
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "execute_command": "sudo -iu root {{.Vars}} {{.Path}}",
      "scripts": [
        "remote-exec/01-basics.sh"
      ]
    }
  ]
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
	packer build -force - <<< "$$Packerfile"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
