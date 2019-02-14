#!/bin/bash

git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
make
make install
cd ..

wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 &> /dev/null
tar xjvf ffmpeg-snapshot.tar.bz2 &> /dev/null
cd ffmpeg

./configure \
--enable-cuda \
--enable-cuvid \
--enable-nvenc \
--enable-nonfree \
--enable-libnpp
--extra-cflags=-I/usr/local/cuda/include \
--extra-ldflags=-L/usr/local/cuda/lib64 \
--extra-cflags=-Ilocal/include \
--disable-shared \
--enable-gpl \
--enable-libass \
--enable-libfdk-aac \
--enable-libfreetype \
--enable-libmp3lame \
--enable-libopus \
--enable-libtheora \
--enable-libvorbis \
--enable-libvpx \
--enable-libxvid \
--enable-version3 \



make -j 10 &> /dev/null
make install