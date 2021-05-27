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

# 安装crosstool-ng
RUN 	cd /bytebox >> /dev/null &&\
	git clone --depth=1 https://github.com/crosstool-ng/crosstool-ng.git &&\
	cd crosstool-ng >> /dev/null &&\
	./bootstrap	&& ./configure && make && sudo make install &&\
	cd .. >> /dev/null &&\
	rm -rf crosstool-ng

# Build Crosstool Toolchain
USER 	bytebox
VOLUME 	/bytebox
COPY 	bytebox-arm-defconfig /bytebox/bytebox-arm-defconfig
COPY 	bytebox-aarch64-defconfig /bytebox/bytebox-aarch64-defconfig

# 拷贝工具链
VOLUME 	/compiler
COPY 	arm-bytebox-linux-gnueabihf /compiler/arm-bytebox-linux-gnueabihf
COPY 	aarch64-bytebox-linux-gnu /bytebox/aarch64-bytebox-linux-gnu

# Set entrypoint
VOLUME 	/playground
COPY 	./entrypoint.sh ./entrypoint.sh
USER 	root
RUN 	["chmod", "+x", "./entrypoint.sh"]
USER 	bytebox

ENTRYPOINT ["./entrypoint.sh"]
