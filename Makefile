SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

SSH_OPTIONS := -o ForwardAgent=yes \
               -o StrictHostKeyChecking=no \
               -o GlobalKnownHostsFile=/dev/null \
               -o UserKnownHostsFile=/dev/null

define PACKER_TASKS
.PHONY: $(1)-disk

$(1)-disk:
	cd $(SELF)/packer/$(1)/ && make build
endef

###

define TERRAFORM_TASKS
.PHONY: $(1)-init $(1)-apply $(1)-destroy

$(1)-init:
	cd $(SELF)/LIVE/$(1)/ && $(SELF)/bin/terragrunt run-all init

$(1)-apply: $(1)-init
	cd $(SELF)/LIVE/$(1)/ \
	&& ($(SELF)/bin/terragrunt run-all apply $(2) || (sleep 1; $(SELF)/bin/terragrunt run-all apply $(2)))

$(1)-destroy: $(1)-init
	-make -f Makefile.SNAPSHOT clean-$(1)
	cd $(SELF)/LIVE/$(1)/ \
	&& ($(SELF)/bin/terragrunt run-all destroy $(2) || (sleep 1; $(SELF)/bin/terragrunt run-all destroy $(2)))
endef

###

define BACKUP_TASKS
.PHONY: $(1)-backup $(1)-restore

$(1)-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-$(1)

$(1)-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-$(1)
endef

###

define SSH_TASKS
.PHONY: $(1)-ssh

$(1)-ssh: $(1)-ssh10

$(1)-ssh%:
	@ssh $(SSH_OPTIONS) $(if $(3),-o ProxyCommand='ssh $(SSH_OPTIONS) $(3) -W %h:%p',) $(4)$$* $(2)
endef

.PHONY: all confirm yes become requirements binaries

all:

c confirm:
	@: $(eval AUTO_APPROVE := --terragrunt-non-interactive)

b become:
	@: $(eval BECOME_ROOT := -t sudo -i)

# EXAMPLE: make c v1-{destroy,apply} sleep30 v2-{destroy,apply}
s% sleep%:
	seq $* | while read -r RETRY; do echo "$$RETRY" && sleep 1; done

requirements: binaries

binaries:
	make -f $(SELF)/Makefile.BINARIES

$(eval $(call PACKER_TASKS,alma))
$(eval $(call PACKER_TASKS,alma_9p))
$(eval $(call PACKER_TASKS,alpine))
$(eval $(call PACKER_TASKS,arch))
$(eval $(call PACKER_TASKS,centos))
$(eval $(call PACKER_TASKS,debian))
$(eval $(call PACKER_TASKS,devuan))
$(eval $(call PACKER_TASKS,dflybsd))
$(eval $(call PACKER_TASKS,fedora))
$(eval $(call PACKER_TASKS,freebsd))
$(eval $(call PACKER_TASKS,kub3lo))
$(eval $(call PACKER_TASKS,kubelo))
$(eval $(call PACKER_TASKS,libvirt))
$(eval $(call PACKER_TASKS,nebula))
$(eval $(call PACKER_TASKS,netbsd))
$(eval $(call PACKER_TASKS,nixos))
$(eval $(call PACKER_TASKS,openbsd))
$(eval $(call PACKER_TASKS,oracle))
$(eval $(call PACKER_TASKS,redhat))
$(eval $(call PACKER_TASKS,redhat_9p))
$(eval $(call PACKER_TASKS,rocky))
$(eval $(call PACKER_TASKS,ubuntu))
$(eval $(call PACKER_TASKS,windows))

$(eval $(call TERRAFORM_TASKS,a1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,b1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,b2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,b3,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,b4,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,c1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,c2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,d1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,d2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,f1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,h1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,k1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,k2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,k3,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,n1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,n2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,n3,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,o1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,r1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,r2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,u1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,v1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,v2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,v3,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,w1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,x1,$$(AUTO_APPROVE)))

$(eval $(call BACKUP_TASKS,a1))
$(eval $(call BACKUP_TASKS,b1))
$(eval $(call BACKUP_TASKS,b2))
$(eval $(call BACKUP_TASKS,b3))
$(eval $(call BACKUP_TASKS,b4))
$(eval $(call BACKUP_TASKS,c1))
$(eval $(call BACKUP_TASKS,c2))
$(eval $(call BACKUP_TASKS,d1))
$(eval $(call BACKUP_TASKS,d2))
$(eval $(call BACKUP_TASKS,f1))
$(eval $(call BACKUP_TASKS,h1))
$(eval $(call BACKUP_TASKS,k1))
$(eval $(call BACKUP_TASKS,k2))
$(eval $(call BACKUP_TASKS,k3))
$(eval $(call BACKUP_TASKS,n1))
$(eval $(call BACKUP_TASKS,n2))
$(eval $(call BACKUP_TASKS,n3))
$(eval $(call BACKUP_TASKS,o1))
$(eval $(call BACKUP_TASKS,r1))
$(eval $(call BACKUP_TASKS,r2))
$(eval $(call BACKUP_TASKS,u1))
$(eval $(call BACKUP_TASKS,v1))
$(eval $(call BACKUP_TASKS,v2))
$(eval $(call BACKUP_TASKS,v3))
$(eval $(call BACKUP_TASKS,w1))
$(eval $(call BACKUP_TASKS,x1))

$(eval $(call SSH_TASKS,a1,$$(BECOME_ROOT),,alpine@10.2.20.))
$(eval $(call SSH_TASKS,b1,$$(BECOME_ROOT),,freebsd@10.2.110.))
$(eval $(call SSH_TASKS,b2,$$(BECOME_ROOT),,openbsd@10.2.111.))
$(eval $(call SSH_TASKS,b3,$$(BECOME_ROOT),,netbsd@10.2.112.))
$(eval $(call SSH_TASKS,b4,$$(BECOME_ROOT),,dflybsd@10.2.113.))
$(eval $(call SSH_TASKS,c1,$$(BECOME_ROOT),,centos@10.2.30.))
$(eval $(call SSH_TASKS,c2,$$(BECOME_ROOT),,almalinux@10.2.31.))
$(eval $(call SSH_TASKS,d1,$$(BECOME_ROOT),,debian@10.2.81.))
$(eval $(call SSH_TASKS,d2,$$(BECOME_ROOT),,devuan@10.2.82.))
$(eval $(call SSH_TASKS,f1,$$(BECOME_ROOT),,fedora@10.2.90.))
$(eval $(call SSH_TASKS,h1,$$(BECOME_ROOT),,arch@10.2.120.))
$(eval $(call SSH_TASKS,k1,$$(BECOME_ROOT),,ubuntu@10.2.40.))
$(eval $(call SSH_TASKS,k2,$$(BECOME_ROOT),,ubuntu@10.2.41.))
$(eval $(call SSH_TASKS,k3,$$(BECOME_ROOT),,alpine@10.2.42.))
$(eval $(call SSH_TASKS,n1,$$(BECOME_ROOT),,ubuntu@10.2.50.))
$(eval $(call SSH_TASKS,n2,$$(BECOME_ROOT),,almalinux@10.2.51.))
$(eval $(call SSH_TASKS,n3,$$(BECOME_ROOT),,cloud-user@10.2.52.))
$(eval $(call SSH_TASKS,o1,$$(BECOME_ROOT),,cloud-user@10.2.60.))
$(eval $(call SSH_TASKS,r1,$$(BECOME_ROOT),,cloud-user@10.2.70.))
$(eval $(call SSH_TASKS,r2,$$(BECOME_ROOT),,rocky@10.2.71.))
$(eval $(call SSH_TASKS,u1,$$(BECOME_ROOT),,ubuntu@10.2.80.))
$(eval $(call SSH_TASKS,v1,$$(BECOME_ROOT),,ubuntu@10.2.51.))
$(eval $(call SSH_TASKS,v2,$$(BECOME_ROOT),ubuntu@10.2.51.10,ubuntu@172.20.100.))
$(eval $(call SSH_TASKS,v3,$$(BECOME_ROOT),ubuntu@10.2.51.11,ubuntu@172.20.100.))
$(eval $(call SSH_TASKS,x1,$$(BECOME_ROOT),,nixos@10.2.100.))

.PHONY: ls clean

ls:
	@machinectl list

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-cd $(SELF)/packer/alma/ && make clean
	-cd $(SELF)/packer/alma_9p/ && make clean
	-cd $(SELF)/packer/alpine/ && make clean
	-cd $(SELF)/packer/arch/ && make clean
	-cd $(SELF)/packer/centos/ && make clean
	-cd $(SELF)/packer/debian/ && make clean
	-cd $(SELF)/packer/devuan/ && make clean
	-cd $(SELF)/packer/dflysbd/ && make clean
	-cd $(SELF)/packer/fedora/ && make clean
	-cd $(SELF)/packer/freebsd/ && make clean
	-cd $(SELF)/packer/kub3lo/ && make clean
	-cd $(SELF)/packer/kubelo/ && make clean
	-cd $(SELF)/packer/libvirt/ && make clean
	-cd $(SELF)/packer/netbsd/ && make clean
	-cd $(SELF)/packer/nixos/ && make clean
	-cd $(SELF)/packer/nebula/ && make clean
	-cd $(SELF)/packer/openbsd/ && make clean
	-cd $(SELF)/packer/oracle/ && make clean
	-cd $(SELF)/packer/redhat/ && make clean
	-cd $(SELF)/packer/redhat_9p/ && make clean
	-cd $(SELF)/packer/rocky/ && make clean
	-cd $(SELF)/packer/ubuntu/ && make clean
	-cd $(SELF)/packer/windows/ && make clean
