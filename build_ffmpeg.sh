#!/bin/bash

git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
make
make install
cd ..

wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg

./configure \
--enable-nonfree \
--disable-shared \
--enable-nvenc \
--enable-cuda \
--enable-cuvid \
--enable-libnpp \
--extra-cflags=-Ilocal/include \
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
--disable-debug \
--disable-ffplay \
--disable-indev=sndio \
--disable-outdev=sndio \
--extra-cflags=-I/usr/local/cuda/include \
--extra-ldflags=-L/usr/local/cuda/lib64

make -j 10
make install