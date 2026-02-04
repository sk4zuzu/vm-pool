SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

NAME := freebsd

RELEASE  := 15.0-RELEASE
VERSION  := $(RELEASE)
ARTIFACT := FreeBSD-$(VERSION)-amd64-BASIC-CLOUDINIT-ufs.qcow2
CHECKSUM := aad747926ecf4f393078031b99c8dfbca7eea0810517340baae4dc6d1a411d60

CPUS      ?= 1
MEMORY    ?= 2048
DISK_SIZE ?= 10240

PACKER             := $(SELF)/../../bin/packer
PACKER_PLUGIN_PATH := $(SELF)/../../bin
PACKER_LOG         ?= 1
HEADLESS           ?= true

define PACKERFILE
source "qemu" "$(NAME)" {
  accelerator = "kvm"

  disk_image   = true
  iso_url      = "file://$(SELF)/.cache/$(ARTIFACT)"
  iso_checksum = "$(CHECKSUM)"

  memory    = "$(MEMORY)"
  disk_size = "$(DISK_SIZE)"

  qemuargs = [
    ["-serial", "stdio"],
  ]

  ssh_username     = "root"
  ssh_password     = "asd"
  shutdown_command = "/sbin/poweroff"

  output_directory = "$(SELF)/.cache/output/"
  vm_name          = "packer-$(NAME).qcow2"

  headless = $(HEADLESS)

  http_directory = "$(SELF)/remote-exec/"

  boot_wait = "45s"

  boot_command = [
	"root<enter><wait1s>",
	"ftp -o- http://{{.HTTPIP}}:{{.HTTPPort}}/00-bootstrap.sh | sh<enter>",
  ]
}
build {
  sources = ["source.qemu.$(NAME)"]
  provisioner "shell" {
    execute_command = "env {{.Vars}} bash --login {{.Path}}"
    scripts = [
      "remote-exec/01-basics.sh",
      "remote-exec/99-fixes.sh",
    ]
  }
}
endef

export

.PHONY: all

all: build

$(SELF)/.cache/$(ARTIFACT):
	install -d $(SELF)/.cache/
	curl -fL https://download.freebsd.org/releases/VM-IMAGES/$(VERSION)/amd64/Latest/$(ARTIFACT).xz \
	| xzcat >$@

.PHONY: build

build: $(SELF)/.cache/output/packer-$(NAME).qcow2

$(SELF)/.cache/output/packer-$(NAME).qcow2: $(SELF)/.cache/$(ARTIFACT) Makefile $(wildcard $(SELF)/remote-exec/*.sh)
	if ! [[ -e $(SELF)/.cache/build.pkr.hcl ]]; then ln -s /dev/stdin $(SELF)/.cache/build.pkr.hcl; fi
	$(PACKER) build -force $(SELF)/.cache/build.pkr.hcl <<< "$$PACKERFILE"

.PHONY: clean

clean:
	-rm -rf $(SELF)/.cache/
