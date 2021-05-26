FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# Install some software
RUN 	apt update -y  &&						\
	apt upgrade -y &&						\
	apt install -y							\
	gcc								\
	grep								\
	sed								\
	gawk								\
	autoconf							\
	automake							\
	bison								\
	bzip2								\
	flex								\
	texinfo								\
	libtool-bin							\
	git								\
	gperf								\
	make								\
	python								\
	texinfo								\
	unrar								\
	unzip								\
	wget								\
	sudo								\
	doxygen								\
	tar								\
	sudo								\
	python3-pip							\
	help2man							\
	lzip								\
	libncurses5-dev							\
	apt-utils 							\
	ca-certificates							\
	u-boot-tools							\
	linux-headers-$(uname -r)

# Add user and add directory
USER 	root
RUN 	useradd -m -s /bin/bash bytebox && passwd -d bytebox &&\
	echo "bytebox      ALL = NOPASSWD: ALL" >> /etc/sudoers	&&\
	mkdir -p /compiler   && chown -R bytebox:bytebox /compiler &&\
	mkdir -p /bytebox    && chown -R bytebox:bytebox /bytebox &&\
	mkdir -p /playground && chown -R bytebox:bytebox /playground

# Build Crosstool Toolchain
USER 	bytebox
VOLUME 	/bytebox
COPY 	bytebox-arm-defconfig /bytebox/bytebox-arm-defconfig
COPY 	bytebox-aarch64-defconfig /bytebox/bytebox-aarch64-defconfig

# 安装crosstool-ng
RUN 	cd /bytebox >> /dev/null &&\
	git clone --depth=1 https://github.com/crosstool-ng/crosstool-ng &&\
	cd crosstool-ng >> /dev/null &&\
	./bootstrap	&& ./configure && make && sudo make install &&\
	cd .. >> /dev/null &&\
	rm -rf crosstool-ng

# 编译 aarch64-unknown-linux-gnu
RUN	cd /bytebox >> /dev/null &&\
	cp bytebox-arm-defconfig .config	&&\
	ct-ng build &&\
	cd .. >> /dev/null

# 编译 arm-cortexa9_neon-linux-gnueabihf
RUN	cd /bytebox >> /dev/null && \
	ct-ng bytebox-aarch64-defconfig .config &&\
	ct-ng build &&\
	cd .. >> /dev/null

# Set entrypoint
VOLUME 	/playground
COPY 	./entrypoint.sh ./entrypoint.sh
USER 	root
RUN 	["chmod", "+x", "./entrypoint.sh"]
USER 	bytebox

ENTRYPOINT ["./entrypoint.sh"]
