FROM ubuntu:20.10

# Install some software
RUN apt update -y &&							\
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
	cmake								\
	doxygen								\
	tar								\
	sudo								\
	python3-pip							\
	help2man							\
	lzip								\
	libncurses5-dev

# Add user and add directory
USER root
RUN useradd -m -s /bin/bash bytebox && passwd -d bytebox		&&\
	echo "bytebox      ALL = NOPASSWD: ALL" >> /etc/sudoers		&&\
	mkdir -p /compiler   && chown -R bytebox:bytebox /compiler	&&\
	mkdir -p /bytebox    && chown -R bytebox:bytebox /bytebox	&&\
	mkdir -p /playground && chown -R bytebox:bytebox /playground

# Build Crosstool Toolchain
USER bytebox
COPY bytebox-arm-defconfig /home/bytebox/bytebox-arm-defconfig
COPY bytebox-aarch64-defconfig /home/bytebox/bytebox-aarch64-defconfig
RUN cd /home/bytebox >> /dev/null						&&\
	git clone --depth=1 https://github.com/crosstool-ng/crosstool-ng.git	&&\
	cd crosstool-ng >> /dev/null						&&\
	./bootstrap	&& ./configure && make && sudo make install		&&\
	cd .. >> /dev/null							&&\
	rm -rf crosstool-ng							&&\
	ct-ng aarch64-unknown-linux-gnu						&&\
	ct-ng build								&&\
	ct-ng arm-cortexa9_neon-linux-gnueabihf					&&\
	ct-ng build								&&\
	rm -rf *								&&\
	cd ../../ >> /dev/null

# Set entrypoint
VOLUME /playground
COPY ./entrypoint.sh ./entrypoint.sh
USER root
RUN ["chmod", "+x", "./entrypoint.sh"]
USER bytebox

ENTRYPOINT ["./entrypoint.sh"]
