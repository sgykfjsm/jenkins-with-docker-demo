FROM ubuntu:12.04
MAINTAINER shigeyuki.fujishima <shigeyuki.fujishima_at_gmail.com>

# Make workspace
RUN mkdir /workspace

RUN apt-get -q update; apt-get -y upgrade
RUN apt-get -y install build-essential sudo curl wget git-core

# Install NVM
RUN git clone --depth 1 https://github.com/creationix/nvm.git /opt/nvm

# Install node
RUN bash -c "source /opt/nvm/nvm.sh; nvm install 0.8"
RUN bash -c "source /opt/nvm/nvm.sh; nvm install 0.10"
RUN bash -c "source /opt/nvm/nvm.sh; nvm install 0.11"

ENTRYPOINT ["/bin/bash", "-c"]
