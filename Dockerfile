FROM nvidia/cuda
LABEL maintainer="Scott <scott.case.1@gmail.com>"

WORKDIR /tmp

ADD build-ffmpeg.sh build-ffmpeg.sh
ADD requirements.txt requirements.txt
RUN chmod +x build-ffmpeg.sh

RUN apt-get update && \
    apt-get install -y autoconf automake build-essential libass-dev libfreetype6-dev \
    libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev libpng-dev pkg-config texinfo zlib1g-dev yasm libmp3lame-dev libxvidcore-dev \
    libopus-dev libxmu-dev freeglut3 freeglut3-dev screen git libfdk-aac-dev libvpx-dev libx264-dev \
    mercurial cmake wget python3-setuptools python3-pip

################################
### Config:
###

# Add pip requirements
COPY /requirements.txt /tmp/requirements.txt
COPY /build_ffmpeg.sh /tmp/build_ffmpeg.sh


### Install pyinotify service.
RUN \
    echo "**** Install pip packages ****" \
        && python3 -m pip install --no-cache-dir -r /tmp/requirements.txt  \
    && \
    echo "**** Install ffmpeg ****" \
        && RUN ./build-ffmpeg.sh \
    && \
    echo "**** Cleanup ****" \
        && rm -rf \
            /tmp/* \
            /var/tmp/*


### Add local files
COPY /docker/root   /
COPY /              /app/


### Environment variables
ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

