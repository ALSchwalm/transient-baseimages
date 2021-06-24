
UBUNTU_20_04_URL="http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.2-base-amd64.tar.gz"
UBUNTU_20_04_BASE=ubuntu-20.04.tar.gz
UBUNTU_20_04_IMAGEFILE=Imagefile.ubuntu2004
UBUNTU_20_04_NAME=ubuntu-20.04

CENTOS_7_8_URL="https://github.com/CentOS/sig-cloud-instance-images/raw/CentOS-7.8.2003-x86_64/docker/centos-7.8.2003-x86_64-docker.tar.xz"
CENTOS_7_8_BASE=centos-7.8.2003.tar.xz
CENTOS_7_8_IMAGEFILE=Imagefile.centos78
CENTOS_7_8_NAME=centos-7.8.2003

CENTOS_8_3_URL="https://github.com/CentOS/sig-cloud-instance-images/raw/ccd17799397027acf9ee6d660e75b8fce4c852e8/docker/centos-8-x86_64.tar.xz"
CENTOS_8_3_BASE=centos-8.3.2011.tar.xz
CENTOS_8_3_IMAGEFILE=Imagefile.centos83
CENTOS_8_3_NAME=centos-8.3.2011

DEBIAN_BUSTER_URL="https://github.com/debuerreotype/docker-debian-artifacts/blob/38b06b2a8a31d805359f1ca3ef5f3203b8a536a7/stable/rootfs.tar.xz?raw=true"
DEBIAN_BUSTER_BASE=debian-buster.tar.xz
DEBIAN_BUSTER_IMAGEFILE=Imagefile.debianBuster
DEBIAN_BUSTER_NAME=debian-buster

ALPINE_3_13_URL="https://github.com/alpinelinux/docker-alpine/blob/db57c96bfff7363dd9bccc56a0ce6e846261bbf8/x86_64/alpine-minirootfs-3.13.4-x86_64.tar.gz?raw=true"
ALPINE_3_13_BASE=alpine-3.13.tar.xz
ALPINE_3_13_IMAGEFILE=Imagefile.alpine313
ALPINE_3_13_NAME=alpine-3.13

PLATFORMS := ubuntu-20.04 centos-7.8 centos-8.3 debian-buster alpine-3.13

all: $(PLATFORMS)
test: $(addprefix test-,$(PLATFORMS))

build/%.qcow2.xz : build/%.qcow2
	xz -k $<

build:
	mkdir -p build
	cp -r assets/* build/

test-build-%: build/%
	./scripts/test_image.sh build/$*

interactive-build-%: build/%
	./scripts/test_image.sh -i build/$*


build/$(UBUNTU_20_04_BASE): | build
	curl -L $(UBUNTU_20_04_URL) -o $@

build/$(UBUNTU_20_04_NAME).qcow2: build/$(UBUNTU_20_04_BASE)
	transient build -f $(UBUNTU_20_04_IMAGEFILE) build/ -local -name $(UBUNTU_20_04_NAME)

.PHONY: ubuntu-20.04 test-ubuntu-20.04 interactive-ubuntu-20.04
ubuntu-20.04: build/$(UBUNTU_20_04_NAME).qcow2.xz
test-ubuntu-20.04: test-build-$(UBUNTU_20_04_NAME).qcow2.xz
interactive-ubuntu-20.04: interactive-build-$(UBUNTU_20_04_NAME).qcow2.xz


build/$(CENTOS_7_8_BASE): | build
	curl -L $(CENTOS_7_8_URL) -o $@

build/$(CENTOS_7_8_NAME).qcow2: build/$(CENTOS_7_8_BASE)
	transient build -f $(CENTOS_7_8_IMAGEFILE) build/ -local -name $(CENTOS_7_8_NAME)

.PHONY: centos-7.8 test-centos-7.8 interactive-centos-7.8
centos-7.8: build/$(CENTOS_7_8_NAME).qcow2.xz
test-centos-7.8: test-build-$(CENTOS_7_8_NAME).qcow2.xz
interactive-centos-7.8: interactive-build-$(CENTOS_7_8_NAME).qcow2.xz


build/$(CENTOS_8_3_BASE): | build
	curl -L $(CENTOS_8_3_URL) -o $@

build/$(CENTOS_8_3_NAME).qcow2: build/$(CENTOS_8_3_BASE)
	transient build -f $(CENTOS_8_3_IMAGEFILE) build/ -local -name $(CENTOS_8_3_NAME)

.PHONY: centos-8.3 test-centos-8.3 interactive-centos-8.3
centos-8.3: build/$(CENTOS_8_3_NAME).qcow2.xz
test-centos-8.3: test-build-$(CENTOS_8_3_NAME).qcow2.xz
interactive-centos-8.3: interactive-build-$(CENTOS_8_3_NAME).qcow2.xz


build/$(DEBIAN_BUSTER_BASE): | build
	curl -L $(DEBIAN_BUSTER_URL) -o $@

build/$(DEBIAN_BUSTER_NAME).qcow2: build/$(DEBIAN_BUSTER_BASE)
	transient build -f $(DEBIAN_BUSTER_IMAGEFILE) build/ -local -name $(DEBIAN_BUSTER_NAME)

.PHONY: debian-buster test-debian-buster interactive-debian-buster
debian-buster: build/$(DEBIAN_BUSTER_NAME).qcow2.xz
test-debian-buster: test-build-$(DEBIAN_BUSTER_NAME).qcow2.xz
interactive-debian-buster: interactive-build-$(DEBIAN_BUSTER_NAME).qcow2.xz


build/$(ALPINE_3_13_BASE): | build
	curl -L $(ALPINE_3_13_URL) -o $@

build/$(ALPINE_3_13_NAME).qcow2: build/$(ALPINE_3_13_BASE)
	transient build -f $(ALPINE_3_13_IMAGEFILE) build/ -local -name $(ALPINE_3_13_NAME)

.PHONY: alpine-3.13 test-alpine-3.13 interactive-alpine-3.13
alpine-3.13: build/$(ALPINE_3_13_NAME).qcow2.xz
test-alpine-3.13: test-build-$(ALPINE_3_13_NAME).qcow2.xz
interactive-alpine-3.13: interactive-build-$(ALPINE_3_13_NAME).qcow2.xz


.PHONY: clean
clean:
	rm -rf build/
