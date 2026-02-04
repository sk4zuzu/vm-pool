SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := windows

VERSION1 := 2022
VERSION2 := 2k22
ARTIFACT := SERVER_EVAL_x64FRE_en-us.iso
CHECKSUM := 3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325

VIRTIO_RELEASE  := 0.1.285
VIRTIO_VERSION  := $(VIRTIO_RELEASE)-1
VIRTIO_ARTIFACT := virtio-win-$(VIRTIO_RELEASE).iso

CLOUDBASE_VERSION  := 1.1.6
CLOUDBASE_ARTIFACT := CloudbaseInitSetup_1_1_6_x64.msi

FIRMWARE  ?= $(SELF)/../../bin/OVMF.fd
CPUS      ?= 2
MEMORY    ?= 3072
DISK_SIZE ?= 32768

PACKER             := $(SELF)/../../bin/packer
PACKER_PLUGIN_PATH := $(SELF)/../../bin
PACKER_LOG         ?= 1
HEADLESS           ?= true

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = false
  iso_url      = "file://$(SELF)/../../files/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  cd_files = [
    "$(SELF)/remote-exec/",
    "$(SELF)/.cache/virtio-win/",
    "$(SELF)/.cache/$(CLOUDBASE_ARTIFACT)",
  ]

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  firmware = "$(FIRMWARE)"

  qemuargs = [
    ["-cpu", "host"],
    ["-smp", "cpus=$(CPUS)"],
  ]

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_password = "asd"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "10m"

  headless = $(HEADLESS)

  boot_wait = "1s"

  boot_command = [
    "<wait1s><enter><wait1s><enter><wait1s><enter><wait1s><enter>",
  ]

  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"asd\""
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

$(SELF)/.cache/output/packer-$(NAME).qcow2: Makefile $(wildcard $(SELF)/remote-exec/*.sh) virtio cloudbase
	install -d $(SELF)/.cache/
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: virtio

virtio: $(SELF)/.cache/virtio-win/NetKVM/ $(SELF)/.cache/virtio-win/viostor/

$(SELF)/.cache/$(VIRTIO_ARTIFACT):
	install -d $(SELF)/.cache/
	curl -fsSLo $@ \
	https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-$(VIRTIO_VERSION)/$(VIRTIO_ARTIFACT)

$(SELF)/.cache/virtio-win/NetKVM/: $(SELF)/.cache/$(VIRTIO_ARTIFACT)
	install -d $@/$(VERSION2)/amd64/
	isoinfo -i $< -f | grep -e ^/NetKVM/$(VERSION2)/amd64/ | while read FILE; do \
	    isoinfo -i $< -x "$$FILE" > $@/$(VERSION2)/amd64/$$(basename "$$FILE"); \
	done

$(SELF)/.cache/virtio-win/viostor/: $(SELF)/.cache/$(VIRTIO_ARTIFACT)
	install -d $@/$(VERSION2)/amd64/
	isoinfo -i $< -f | grep -e ^/viostor/$(VERSION2)/amd64/ | while read FILE; do \
	    isoinfo -i $< -x "$$FILE" > $@/$(VERSION2)/amd64/$$(basename "$$FILE"); \
	done

.PHONY: cloudbase

cloudbase: $(SELF)/.cache/$(CLOUDBASE_ARTIFACT)

$(SELF)/.cache/$(CLOUDBASE_ARTIFACT):
	install -d $(SELF)/.cache/
	curl -fsSLo $@ \
	https://github.com/cloudbase/cloudbase-init/releases/download/$(CLOUDBASE_VERSION)/$(CLOUDBASE_ARTIFACT)

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
