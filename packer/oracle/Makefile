SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := oracle

VERSION  := 7U9
ARTIFACT := OL$(VERSION)_x86_64-olvm-b86.qcow2
CHECKSUM := 2ef4c10c0f6a0b17844742adc9ede7eb64a2c326e374068b7175f2ecbb1956fb

CPUS      ?= 1
MEMORY    ?= 1024
DISK_SIZE ?= 40960

PACKER_LOG ?= 1
HEADLESS   ?= true

define CLOUD_CONFIG
#cloud-config
ssh_pwauth: true
users:
  - name: 'cloud-user'
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false
chpasswd:
  list:
    - 'cloud-user:oracle'
  expire: false
endef

define Packerfile
{
  "builders": [
    {
      "type": "qemu",
      "accelerator": "kvm",

      "disk_image": "true",
      "iso_url": "http://yum.oracle.com/templates/OracleLinux/OL7/u9/x86_64/$(ARTIFACT)",
      "iso_checksum": "$(CHECKSUM)",

      "memory": "$(MEMORY)",
      "disk_size": "$(DISK_SIZE)",

      "qemuargs": [
        ["-cdrom", "$(SELF)/.cache/$(ARTIFACT).iso"]
      ],

      "ssh_username": "cloud-user",
      "ssh_password": "oracle",

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
	$(SELF)/../../bin/packer build -force - <<< "$$Packerfile"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
