
UBUNTU_20_04_URL="http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.2-base-amd64.tar.gz"
UBUNTU_20_04_BASE=ubuntu-20.04.tar.gz
UBUNTU_20_04_IMAGEFILE=Imagefile.ubuntu2004
UBUNTU_20_04_NAME=ubuntu-20.04

CENTOS_7_8_URL="https://github.com/CentOS/sig-cloud-instance-images/raw/CentOS-7.8.2003-x86_64/docker/centos-7.8.2003-x86_64-docker.tar.xz"
CENTOS_7_8_BASE=centos-7.8.2003.tar.xz
CENTOS_7_8_IMAGEFILE=Imagefile.centos78
CENTOS_7_8_NAME=centos-7.8.2003

all: ubuntu-20.04 centos-7.8

build:
	mkdir -p build
	cp -r assets/* build/

build/$(UBUNTU_20_04_BASE): | build
	curl -L $(UBUNTU_20_04_URL) -o $@

build/$(UBUNTU_20_04_NAME).qcow2: build/$(UBUNTU_20_04_BASE)
	transient build -f $(UBUNTU_20_04_IMAGEFILE) build/ -local -name $(UBUNTU_20_04_NAME)

.PHONY: ubuntu-20.04
ubuntu-20.04: build/$(UBUNTU_20_04_NAME).qcow2


build/$(CENTOS_7_8_BASE): | build
	curl -L $(CENTOS_7_8_URL) -o $@

build/$(CENTOS_7_8_NAME).qcow2: build/$(CENTOS_7_8_BASE)
	transient build -f $(CENTOS_7_8_IMAGEFILE) build/ -local -name $(CENTOS_7_8_NAME)

.PHONY: centos-7.8
centos-7.8: build/$(CENTOS_7_8_NAME).qcow2


.PHONY: clean
clean:
	rm -rf build/
