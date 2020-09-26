FROM archlinux

RUN pacman --noconfirm  -Syu &&			\
	pacman -S --need --noconfirm		\
	clang								\
	llvm								\
	vim									\
	grep								\
	sed									\
	gawk								\
	uboot-tools							\
	autoconf							\
	automake							\
	bison								\
	bzip2								\
	flex								\
	git									\
	gperf								\
	make								\
	python								\
	texinfo								\
	unrar								\
	unzip								\
	wget								\
	sudo								\
	cmake								\
	scons								\
	doxygen								\
	hugo								\
	tar									\
	sudo								\
	pacman								\
	go									\
	rust								\
	base-devel							\
	zsh									\
	neofetch							\
	python-virtualenv					\
	python-pip							\
	help2man							\
	lzip								\
	axel								\
	rsync

USER root
RUN useradd -m -s /bin/bash bytebox &&\
	passwd -d bytebox &&\
	echo "bytebox      ALL = NOPASSWD: ALL" >> /etc/sudoers &&\
	mkdir -p /compiler && chmod -R bytebox:bytebox /compiler &&\
	mkdir -p /playground && chmod -R bytebox:bytebox /playground

RUN pushd /compiler &&\
	git clone https://github.com/crosstool-ng/crosstool-ng &&\
	pushd crosstool-ng &&\
	./bootstrap &&\
	./configure &&\
	make &&\
	sudo make install &&\	
	popd &&\
	rm -rf crosstool-ng &&\
	ct-ng arm-cortexa9_neon-linux-gnueabihf &&\
	ct-ng build &&\
	popd

VOLUME /playground

COPY ./entrypoint.sh ./entrypoint.sh
USER root
RUN ["chmod", "+x", "./entrypoint.sh"]
USER bytebox

ENTRYPOINT ["./entrypoint.sh"]
