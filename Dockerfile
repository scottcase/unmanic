FROM lsiobase/ubuntu:bionic
LABEL maintainer="Scott <scott.case.1@gmail.com>"

#Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

ENV DEBIAN_FRONTEND=noninteractive

ADD buildffmpeg.sh buildffmpeg.sh
ADD requirements.txt requirements.txt


RUN apt-get update && \
    apt-get install -y autoconf automake build-essential libass-dev libfreetype6-dev \
    libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev libpng-dev pkg-config texinfo zlib1g-dev yasm libmp3lame-dev libxvidcore-dev \
    libopus-dev libxmu-dev freeglut3 freeglut3-dev screen git libfdk-aac-dev libvpx-dev libx264-dev \
    mercurial cmake wget python3-setuptools python3-pip nano tzdata curl

################################
### Config:
###

# Add pip requirements
COPY /requirements.txt /tmp/requirements.txt
COPY /buildffmpeg.sh /tmp/buildffmpeg.sh
RUN chmod +x /tmp/buildffmpeg.sh

### Install ffmpeg
RUN echo "**** Install ffmpeg ****" && /tmp/buildffmpeg.sh

### Install pyinotify service.
RUN \
    echo "**** Install pip packages ****" \
        && python3 -m pip install --no-cache-dir -r /tmp/requirements.txt  \
    && \
    echo "**** Cleanup ****" \
        && rm -rf \
            /tmp/* \
            /var/tmp/*



### Add local files
COPY /docker/root   /
COPY /root/         /
COPY /              /app/
RUN chmod +x /app/service.py

EXPOSE 8888
VOLUME /config
VOLUME /logs
WORKDIR /app

### Environment variables
ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
    
### CMD [ "python3", "/app/service.py" ]