FROM ubuntu:18.04

# TODO: install-tl-ubuntu (very slowly) installs the texlive-full profile
RUN apt-get update
RUN apt-get install -y wget make software-properties-common

RUN apt-get install -y tzdata
RUN apt-get install -y texlive-full

ADD . /resume
WORKDIR /resume

ENTRYPOINT make _docker_entrypoint
