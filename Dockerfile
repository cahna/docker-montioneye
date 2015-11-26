
FROM ubuntu:15.04
MAINTAINER Conor Heine <conor.heine@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV export LANGUAGE=en_US.UTF-8
ENV export LC_ALL=en_US.UTF-8
ENV export LANG=en_US.UTF-8
ENV export LC_TYPE=en_US.UTF-8

RUN apt-get update

# Core dependencies
RUN apt-get --yes install \
        git \
        motion \
        ffmpeg \
        v4l-utils \
        python-pip \
        libssl-dev \
        libjpeg-dev \
        libcurl4-openssl-dev

 # Python
RUN apt-get --yes install \
        python2.7 \
        python-setuptools \
        python-dev \
        python-pip

# Pip
RUN pip install tornado jinja2 pillow pycurl

# Fetch motioneye src
RUN cd /tmp && git clone https://bitbucket.org/ccrisan/motioneye.git && \
    cd /tmp/motioneye && python setup.py install && mkdir /etc/motioneye && \
    cp /tmp/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf && \
    rm -rf /tmp/*

VOLUME /etc/motion
VOLUME /var/run/motion

WORKDIR /motioneye
CMD /usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf
EXPOSE 8765

