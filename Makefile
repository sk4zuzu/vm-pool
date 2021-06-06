SHELL := $(shell which bash)
SELF  := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

SSH_OPTIONS := -o ForwardAgent=yes \
               -o StrictHostKeyChecking=no \
               -o GlobalKnownHostsFile=/dev/null \
               -o UserKnownHostsFile=/dev/null


.PHONY: all confirm yes requirements

all:

confirm: yes
yes:
	@: $(eval AUTO_APPROVE := --terragrunt-non-interactive)

requirements: binaries extras


.PHONY: binaries extras

binaries:
	make -f $(SELF)/Makefile.BINARIES

extras:
	make -f $(SELF)/Makefile.EXTRAS


.PHONY: kubelo-disk redhat-disk ubuntu-disk

kubelo-disk:
	cd $(SELF)/packer/kubelo/ && make build

redhat-disk:
	cd $(SELF)/packer/redhat/ && make build

ubuntu-disk:
	cd $(SELF)/packer/ubuntu/ && make build


.PHONY: k1-init k1-apply k1-destroy

k1-init:
	cd $(SELF)/LIVE/k1/ && $(SELF)/bin/terragrunt run-all init

k1-apply: k1-init
	cd $(SELF)/LIVE/k1/ && $(SELF)/bin/terragrunt run-all apply $(AUTO_APPROVE)

k1-destroy: k1-init
	-make -f Makefile.SNAPSHOT clean-k1
	cd $(SELF)/LIVE/k1/ && $(SELF)/bin/terragrunt run-all destroy $(AUTO_APPROVE)


.PHONY: r1-init r1-apply r1-destroy

r1-init:
	cd $(SELF)/LIVE/r1/ && $(SELF)/bin/terragrunt run-all init

r1-apply: r1-init
	cd $(SELF)/LIVE/r1/ && $(SELF)/bin/terragrunt run-all apply $(AUTO_APPROVE)

r1-destroy: r1-init
	-make -f Makefile.SNAPSHOT clean-r1
	cd $(SELF)/LIVE/r1/ && $(SELF)/bin/terragrunt run-all destroy $(AUTO_APPROVE)


.PHONY: u1-init u1-apply u1-destroy

u1-init:
	cd $(SELF)/LIVE/u1/ && $(SELF)/bin/terragrunt run-all init

u1-apply: u1-init
	cd $(SELF)/LIVE/u1/ && $(SELF)/bin/terragrunt run-all apply $(AUTO_APPROVE)

u1-destroy: u1-init
	-make -f Makefile.SNAPSHOT clean-u1
	cd $(SELF)/LIVE/u1/ && $(SELF)/bin/terragrunt run-all destroy $(AUTO_APPROVE)


.PHONY: k1-backup k1-restore

k1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-k1

k1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-k1


.PHONY: r1-backup r1-restore

r1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-r1

r1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-r1


.PHONY: u1-backup u1-restore

u1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-u1

u1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-u1


.PHONY: become k1-ssh r1-ssh u1-ssh

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

k1-ssh: k1-ssh10

r1-ssh: r1-ssh10

u1-ssh: u1-ssh10

k1-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.30.2.$* $(BECOME_ROOT)

r1-ssh%:
	@ssh $(SSH_OPTIONS) cloud-user@10.40.2.$* $(BECOME_ROOT)

u1-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.50.2.$* $(BECOME_ROOT)


.PHONY: clean

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-make clean -f $(SELF)/Makefile.EXTRAS
	-cd $(SELF)/packer/kubelo/ && make clean
	-cd $(SELF)/packer/redhat/ && make clean
	-cd $(SELF)/packer/ubuntu/ && make clean
