FROM ubuntu:14.04

# TODO: install-tl-ubuntu (very slowly) installs the texlive-full profile
RUN apt-get install -y wget make software-properties-common

RUN wget -q -O install-tl-unx.tar.gz \
  http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN mkdir install-tl && \
  tar -C install-tl --strip-components 1 -xf install-tl-unx.tar.gz
COPY texlive.profile /install-tl/texlive.profile
RUN cd /install-tl && ./install-tl -profile texlive.profile

ENV PATH /usr/local/texlive/2014/bin/x86_64-linux:$PATH
RUN tlmgr install titlesec changepage enumitem \
      parskip tabulary ifsym palatino helvetic

ADD . /resume
WORKDIR /resume

ENTRYPOINT make _entrypoint
