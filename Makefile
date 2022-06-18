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
	cd $(SELF)/LIVE/$(1)/ && $(SELF)/bin/terragrunt run-all apply $(2)

$(1)-destroy: $(1)-init
	-make -f Makefile.SNAPSHOT clean-$(1)
	cd $(SELF)/LIVE/$(1)/ && $(SELF)/bin/terragrunt run-all destroy $(2)
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
	@ssh $(SSH_OPTIONS) $(3)$$* $(2)
endef

.PHONY: all confirm yes become requirements binaries

all:

c confirm:
	@: $(eval AUTO_APPROVE := --terragrunt-non-interactive)

b become:
	@: $(eval BECOME_ROOT := -t sudo -i)

requirements: binaries

binaries:
	make -f $(SELF)/Makefile.BINARIES

$(eval $(call PACKER_TASKS,almaos))
$(eval $(call PACKER_TASKS,alpine))
$(eval $(call PACKER_TASKS,centos))
$(eval $(call PACKER_TASKS,kub3lo))
$(eval $(call PACKER_TASKS,kubelo))
$(eval $(call PACKER_TASKS,nebula))
$(eval $(call PACKER_TASKS,oracle))
$(eval $(call PACKER_TASKS,redhat))
$(eval $(call PACKER_TASKS,ubuntu))

$(eval $(call TERRAFORM_TASKS,a1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,c1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,c2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,k1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,k2,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,k3,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,n1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,o1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,r1,$$(AUTO_APPROVE)))
$(eval $(call TERRAFORM_TASKS,u1,$$(AUTO_APPROVE)))

$(eval $(call BACKUP_TASKS,a1))
$(eval $(call BACKUP_TASKS,c1))
$(eval $(call BACKUP_TASKS,c2))
$(eval $(call BACKUP_TASKS,k1))
$(eval $(call BACKUP_TASKS,k2))
$(eval $(call BACKUP_TASKS,k3))
$(eval $(call BACKUP_TASKS,n1))
$(eval $(call BACKUP_TASKS,o1))
$(eval $(call BACKUP_TASKS,r1))
$(eval $(call BACKUP_TASKS,u1))

$(eval $(call SSH_TASKS,a1,$$(BECOME_ROOT),alpine@10.2.20.))
$(eval $(call SSH_TASKS,c1,$$(BECOME_ROOT),almalinux@10.2.30.))
$(eval $(call SSH_TASKS,c2,$$(BECOME_ROOT),centos@10.2.31.))
$(eval $(call SSH_TASKS,k1,$$(BECOME_ROOT),ubuntu@10.2.40.))
$(eval $(call SSH_TASKS,k2,$$(BECOME_ROOT),ubuntu@10.2.41.))
$(eval $(call SSH_TASKS,k3,$$(BECOME_ROOT),alpine@10.2.42.))
$(eval $(call SSH_TASKS,n1,$$(BECOME_ROOT),ubuntu@10.2.50.))
$(eval $(call SSH_TASKS,o1,$$(BECOME_ROOT),cloud-user@10.2.60.))
$(eval $(call SSH_TASKS,r1,$$(BECOME_ROOT),cloud-user@10.2.70.))
$(eval $(call SSH_TASKS,u1,$$(BECOME_ROOT),ubuntu@10.2.80.))

.PHONY: clean

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-cd $(SELF)/packer/almaos/ && make clean
	-cd $(SELF)/packer/alpine/ && make clean
	-cd $(SELF)/packer/centos/ && make clean
	-cd $(SELF)/packer/kub3lo/ && make clean
	-cd $(SELF)/packer/kubelo/ && make clean
	-cd $(SELF)/packer/nebula/ && make clean
	-cd $(SELF)/packer/oracle/ && make clean
	-cd $(SELF)/packer/redhat/ && make clean
	-cd $(SELF)/packer/ubuntu/ && make clean
