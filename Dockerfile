FROM ubuntu:14.04

# TODO: install-tl-ubuntu (very slowly) installs the texlive-full profile
RUN apt-get install -y wget make software-properties-common
RUN apt-add-repository multiverse && apt-get update
RUN wget https://github.com/scottkosty/install-tl-ubuntu/raw/master/install-tl-ubuntu && \
          chmod +x ./install-tl-ubuntu
RUN ./install-tl-ubuntu

# TODO: completely manual install, with minimum viable packages
# RUN wget -q -O install-tl-unx.tar.gz \
#   http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
# RUN mkdir install-tl && \
#   tar -C install-tl --strip-components 1 -xf install-tl-unx.tar.gz
# COPY texlive.profile /install-tl/texlive.profile
# RUN cd /install-tl && ./install-tl -profile texlive.profile
# RUN tlmgr install moderncv etoolbox xpackages lingmacros

ADD . /resume
WORKDIR /resume

ENV PATH /usr/local/texlive/2014/bin/x86_64-linux:$PATH
ENTRYPOINT make _entrypoint
