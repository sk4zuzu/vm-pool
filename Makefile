SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

SSH_OPTIONS := -o ForwardAgent=yes \
               -o StrictHostKeyChecking=no \
               -o GlobalKnownHostsFile=/dev/null \
               -o UserKnownHostsFile=/dev/null

define PACKER_TASKS_MAKE
.PHONY: $(1)-disk

$(1)-disk:
	cd $(SELF)/packer/$(1)/ && make build
endef

###

define TERRAFORM_TASKS_MAKE
.PHONY: $(1)-init $(1)-apply $(1)-destroy

$(1)-init:
	cd $(SELF)/LIVE/$(1)/ && $(SELF)/bin/terragrunt run --all init

$(1)-apply: $(1)-init
	cd $(SELF)/LIVE/$(1)/ && $(SELF)/bin/terragrunt run --all apply $(2)

$(1)-destroy: $(1)-init
	-make -f Makefile.SNAPSHOT clean-$(1)
	cd $(SELF)/LIVE/$(1)/ && $(SELF)/bin/terragrunt run --all destroy $(2)
endef

###

define BACKUP_TASKS_MAKE
.PHONY: $(1)-backup $(1)-restore

$(1)-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-$(1)

$(1)-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-$(1)
endef

###

define SSH_TASKS_MAKE
.PHONY: $(1)-ssh

$(1)-ssh: $(1)-ssh10

$(1)-ssh%:
	@ssh $(SSH_OPTIONS) $(if $(3),-o ProxyCommand='ssh $(SSH_OPTIONS) $(3) -W %h:%p',) $(4)$$* $(2)
endef

.PHONY: all confirm yes become requirements binaries

all:

c confirm:
	@: $(eval AUTO_APPROVE := --non-interactive)

b become:
	@: $(eval BECOME_ROOT := -t sudo -i)

# EXAMPLE: make c v1-{destroy,apply} sleep30 v2-{destroy,apply}
s% sleep%:
	seq $* | while read -r RETRY; do echo "$$RETRY" && sleep 1; done

requirements: binaries

binaries:
	make -f $(SELF)/Makefile.BINARIES

$(eval $(call PACKER_TASKS_MAKE,alma))
$(eval $(call PACKER_TASKS_MAKE,alpine))
$(eval $(call PACKER_TASKS_MAKE,arch))
$(eval $(call PACKER_TASKS_MAKE,centos))
$(eval $(call PACKER_TASKS_MAKE,debian))
$(eval $(call PACKER_TASKS_MAKE,dflybsd))
$(eval $(call PACKER_TASKS_MAKE,freebsd))
$(eval $(call PACKER_TASKS_MAKE,kub3lo))
$(eval $(call PACKER_TASKS_MAKE,kubelo))
$(eval $(call PACKER_TASKS_MAKE,netbsd))
$(eval $(call PACKER_TASKS_MAKE,nixos))
$(eval $(call PACKER_TASKS_MAKE,openbsd))
$(eval $(call PACKER_TASKS_MAKE,opensuse))
$(eval $(call PACKER_TASKS_MAKE,redhat))
$(eval $(call PACKER_TASKS_MAKE,rocky))
$(eval $(call PACKER_TASKS_MAKE,suse))
$(eval $(call PACKER_TASKS_MAKE,ubuntu))
$(eval $(call PACKER_TASKS_MAKE,void))
$(eval $(call PACKER_TASKS_MAKE,windows))

$(eval $(call TERRAFORM_TASKS_MAKE,a1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,a2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,b1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,b2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,b3,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,b4,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,c1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,c2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,c3,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,d1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,h1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,k1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,k2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,k3,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,r1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,s1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,s2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,u1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,w1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS_MAKE,x1,$$(AUTO_APPROVE)))

$(eval $(call BACKUP_TASKS_MAKE,a1))
$(eval $(call BACKUP_TASKS_MAKE,a2))
$(eval $(call BACKUP_TASKS_MAKE,b1))
$(eval $(call BACKUP_TASKS_MAKE,b2))
$(eval $(call BACKUP_TASKS_MAKE,b3))
$(eval $(call BACKUP_TASKS_MAKE,b4))
$(eval $(call BACKUP_TASKS_MAKE,c1))
$(eval $(call BACKUP_TASKS_MAKE,c2))
$(eval $(call BACKUP_TASKS_MAKE,c3))
$(eval $(call BACKUP_TASKS_MAKE,d1))
$(eval $(call BACKUP_TASKS_MAKE,h1))
$(eval $(call BACKUP_TASKS_MAKE,k1))
$(eval $(call BACKUP_TASKS_MAKE,k2))
$(eval $(call BACKUP_TASKS_MAKE,k3))
$(eval $(call BACKUP_TASKS_MAKE,r1))
$(eval $(call BACKUP_TASKS_MAKE,s1))
$(eval $(call BACKUP_TASKS_MAKE,s2))
$(eval $(call BACKUP_TASKS_MAKE,u1))
$(eval $(call BACKUP_TASKS_MAKE,w1))
$(eval $(call BACKUP_TASKS_MAKE,x1))

$(eval $(call SSH_TASKS_MAKE,a1,$$(BECOME_ROOT),,alpine@10.2.20.))
$(eval $(call SSH_TASKS_MAKE,a2,$$(BECOME_ROOT),,void@10.2.21.))
$(eval $(call SSH_TASKS_MAKE,b1,$$(BECOME_ROOT),,freebsd@10.2.110.))
$(eval $(call SSH_TASKS_MAKE,b2,$$(BECOME_ROOT),,openbsd@10.2.111.))
$(eval $(call SSH_TASKS_MAKE,b3,$$(BECOME_ROOT),,netbsd@10.2.112.))
$(eval $(call SSH_TASKS_MAKE,b4,$$(BECOME_ROOT),,dflybsd@10.2.113.))
$(eval $(call SSH_TASKS_MAKE,c1,$$(BECOME_ROOT),,cloud-user@10.2.30.))
$(eval $(call SSH_TASKS_MAKE,c2,$$(BECOME_ROOT),,almalinux@10.2.31.))
$(eval $(call SSH_TASKS_MAKE,c3,$$(BECOME_ROOT),,rocky@10.2.32.))
$(eval $(call SSH_TASKS_MAKE,d1,$$(BECOME_ROOT),,debian@10.2.81.))
$(eval $(call SSH_TASKS_MAKE,h1,$$(BECOME_ROOT),,arch@10.2.120.))
$(eval $(call SSH_TASKS_MAKE,k1,$$(BECOME_ROOT),,ubuntu@10.2.40.))
$(eval $(call SSH_TASKS_MAKE,k2,$$(BECOME_ROOT),,ubuntu@10.2.41.))
$(eval $(call SSH_TASKS_MAKE,k3,$$(BECOME_ROOT),,alpine@10.2.42.))
$(eval $(call SSH_TASKS_MAKE,r1,$$(BECOME_ROOT),,cloud-user@10.2.70.))
$(eval $(call SSH_TASKS_MAKE,s1,$$(BECOME_ROOT),,opensuse@10.2.60.))
$(eval $(call SSH_TASKS_MAKE,s2,$$(BECOME_ROOT),,suse@10.2.61.))
$(eval $(call SSH_TASKS_MAKE,u1,$$(BECOME_ROOT),,ubuntu@10.2.80.))
$(eval $(call SSH_TASKS_MAKE,x1,$$(BECOME_ROOT),,asd@10.2.100.))

.PHONY: ls clean

ls:
	@machinectl list

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-cd $(SELF)/packer/alma/ && make clean
	-cd $(SELF)/packer/alpine/ && make clean
	-cd $(SELF)/packer/arch/ && make clean
	-cd $(SELF)/packer/centos/ && make clean
	-cd $(SELF)/packer/debian/ && make clean
	-cd $(SELF)/packer/dflysbd/ && make clean
	-cd $(SELF)/packer/freebsd/ && make clean
	-cd $(SELF)/packer/kub3lo/ && make clean
	-cd $(SELF)/packer/kubelo/ && make clean
	-cd $(SELF)/packer/netbsd/ && make clean
	-cd $(SELF)/packer/nixos/ && make clean
	-cd $(SELF)/packer/openbsd/ && make clean
	-cd $(SELF)/packer/opensuse/ && make clean
	-cd $(SELF)/packer/redhat/ && make clean
	-cd $(SELF)/packer/rocky/ && make clean
	-cd $(SELF)/packer/suse/ && make clean
	-cd $(SELF)/packer/ubuntu/ && make clean
	-cd $(SELF)/packer/void/ && make clean
	-cd $(SELF)/packer/windows/ && make clean
