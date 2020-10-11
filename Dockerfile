FROM archlinux

RUN pacman --noconfirm  -Syu &&			\
	pacman -S --need --noconfirm		\
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
	tar									\
	sudo								\
	pacman								\
	base-devel							\
	zsh									\
	help2man							\
	lzip								\
	axel								\
	rsync

USER root
RUN useradd -m -s /bin/bash bytebox &&\
	passwd -d bytebox &&\
	echo "bytebox      ALL = NOPASSWD: ALL" >> /etc/sudoers &&\
	mkdir -p /compiler && chown -R bytebox:bytebox /compiler &&\
	mkdir -p /playground && chown -R bytebox:bytebox /playground

USER bytebox
COPY config /home/bytebox/.config
RUN pushd /home/bytebox &&\
	git clone https://github.com/crosstool-ng/crosstool-ng &&\
	pushd crosstool-ng &&\
	./bootstrap &&\
	./configure &&\
	make &&\
	sudo make install &&\	
	popd &&\
	rm -rf crosstool-ng &&\
	ct-ng build &&\
	sudo mv x-tools/* /compiler &&\
	rm -rf * &&\
	popd

VOLUME /playground

COPY ./entrypoint.sh ./entrypoint.sh
USER root
RUN ["chmod", "+x", "./entrypoint.sh"]
USER bytebox

ENTRYPOINT ["./entrypoint.sh"]
