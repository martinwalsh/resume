FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y wget make software-properties-common

RUN apt-get install -y tzdata
RUN apt-get install -y texlive-full

WORKDIR /resume
