############################################################
# Dockerfile to build cloneHD workflow container
# Based on Ubuntu
############################################################

FROM ubuntu

# File Author / Maintainer
MAINTAINER Ignacio Vazquez-Garcia <ivg@sanger.ac.uk>

RUN apt-get update && apt-get install -y gfortran build-essential \
make gcc build-essential wget libgsl2 gsl-bin libgsl-dev git \
libblas-dev liblapack-dev python-pip

WORKDIR /opt

RUN pip install PyVCF

# Install software 
RUN apt-get install -y git
# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
ADD id_rsa /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add github key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone -b smchet https://github.com/ivazquez/cloneHD.git
RUN cd cloneHD/src && mkdir ../build && make -f Makefile.farm

RUN git clone -b smchet git@github.com:ivazquez/cloneHD-tools.git
RUN cd cloneHD-tools && python setup.py install
