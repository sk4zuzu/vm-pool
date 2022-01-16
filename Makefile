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

requirements: binaries


.PHONY: binaries

binaries:
	make -f $(SELF)/Makefile.BINARIES


.PHONY: alpine-disk centos-disk kubelo-disk oracle-disk redhat-disk ubuntu-disk

alpine-disk:
	cd $(SELF)/packer/alpine/ && make build

centos-disk:
	cd $(SELF)/packer/centos/ && make build

kubelo-disk:
	cd $(SELF)/packer/kubelo/ && make build

nebula-disk:
	cd $(SELF)/packer/nebula/ && make build

oracle-disk:
	cd $(SELF)/packer/oracle/ && make build

redhat-disk:
	cd $(SELF)/packer/redhat/ && make build

ubuntu-disk:
	cd $(SELF)/packer/ubuntu/ && make build


.PHONY: a1-init a1-apply a1-destroy

a1-init:
	cd $(SELF)/LIVE/a1/ && $(SELF)/bin/terragrunt run-all init

a1-apply: a1-init
	cd $(SELF)/LIVE/a1/ && $(SELF)/bin/terragrunt run-all apply $(AUTO_APPROVE)

a1-destroy: a1-init
	-make -f Makefile.SNAPSHOT clean-a1
	cd $(SELF)/LIVE/a1/ && $(SELF)/bin/terragrunt run-all destroy $(AUTO_APPROVE)


.PHONY: c1-init c1-apply c1-destroy

c1-init:
	cd $(SELF)/LIVE/c1/ && $(SELF)/bin/terragrunt run-all init

c1-apply: c1-init
	cd $(SELF)/LIVE/c1/ && $(SELF)/bin/terragrunt run-all apply $(AUTO_APPROVE)

c1-destroy: c1-init
	-make -f Makefile.SNAPSHOT clean-c1
	cd $(SELF)/LIVE/c1/ && $(SELF)/bin/terragrunt run-all destroy $(AUTO_APPROVE)


.PHONY: k1-init k1-apply k1-destroy

k1-init:
	cd $(SELF)/LIVE/k1/ && $(SELF)/bin/terragrunt run-all init

k1-apply: k1-init
	cd $(SELF)/LIVE/k1/ && $(SELF)/bin/terragrunt run-all apply $(AUTO_APPROVE)

k1-destroy: k1-init
	-make -f Makefile.SNAPSHOT clean-k1
	cd $(SELF)/LIVE/k1/ && $(SELF)/bin/terragrunt run-all destroy $(AUTO_APPROVE)


.PHONY: n1-init n1-apply n1-destroy

n1-init:
	cd $(SELF)/LIVE/n1/ && $(SELF)/bin/terragrunt run-all init

n1-apply: n1-init
	cd $(SELF)/LIVE/n1/ && $(SELF)/bin/terragrunt run-all apply $(AUTO_APPROVE)

n1-destroy: n1-init
	-make -f Makefile.SNAPSHOT clean-n1
	cd $(SELF)/LIVE/n1/ && $(SELF)/bin/terragrunt run-all destroy $(AUTO_APPROVE)


.PHONY: o1-init o1-apply o1-destroy

o1-init:
	cd $(SELF)/LIVE/o1/ && $(SELF)/bin/terragrunt run-all init

o1-apply: o1-init
	cd $(SELF)/LIVE/o1/ && $(SELF)/bin/terragrunt run-all apply $(AUTO_APPROVE)

o1-destroy: o1-init
	-make -f Makefile.SNAPSHOT clean-o1
	cd $(SELF)/LIVE/o1/ && $(SELF)/bin/terragrunt run-all destroy $(AUTO_APPROVE)


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


.PHONY: a1-backup a1-restore

a1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-a1

a1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-a1


.PHONY: c1-backup c1-restore

c1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-c1

c1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-c1


.PHONY: k1-backup k1-restore

k1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-k1

k1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-k1


.PHONY: n1-backup n1-restore

n1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-n1

n1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-n1


.PHONY: o1-backup o1-restore

o1-backup:
	make -f $(SELF)/Makefile.SNAPSHOT backup-o1

o1-restore:
	make -f $(SELF)/Makefile.SNAPSHOT restore-o1


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


.PHONY: become a1-ssh c1-ssh k1-ssh n1-ssh o1-ssh r1-ssh u1-ssh

become:
	@: $(eval BECOME_ROOT := -t sudo -i)

a1-ssh: a1-ssh10

c1-ssh: c1-ssh10

k1-ssh: k1-ssh10

n1-ssh: n1-ssh10

o1-ssh: o1-ssh10

r1-ssh: r1-ssh10

u1-ssh: u1-ssh10

a1-ssh%:
	@ssh $(SSH_OPTIONS) alpine@10.70.2.$* $(BECOME_ROOT)

c1-ssh%:
	@ssh $(SSH_OPTIONS) centos@10.80.2.$* $(BECOME_ROOT)

k1-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.30.2.$* $(BECOME_ROOT)

n1-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.60.2.$* $(BECOME_ROOT)

o1-ssh%:
	@ssh $(SSH_OPTIONS) cloud-user@10.20.2.$* $(BECOME_ROOT)

r1-ssh%:
	@ssh $(SSH_OPTIONS) cloud-user@10.40.2.$* $(BECOME_ROOT)

u1-ssh%:
	@ssh $(SSH_OPTIONS) ubuntu@10.50.2.$* $(BECOME_ROOT)


.PHONY: clean

clean:
	-make clean -f $(SELF)/Makefile.BINARIES
	-cd $(SELF)/packer/alpine/ && make clean
	-cd $(SELF)/packer/centos/ && make clean
	-cd $(SELF)/packer/kubelo/ && make clean
	-cd $(SELF)/packer/nebula/ && make clean
	-cd $(SELF)/packer/oracle/ && make clean
	-cd $(SELF)/packer/redhat/ && make clean
	-cd $(SELF)/packer/ubuntu/ && make clean
