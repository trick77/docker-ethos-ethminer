FROM ubuntu:16.04

ENV ETHMINER_GIT_URL=https://github.com/ethereum-mining/ethminer
ENV ETHMINER_VERSION=0.13.0.dev0
ENV CUDA_TOOLKIT_URL=https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y python build-essential mesa-common-dev g++-4.8 gcc-4.8 cmake curl wget git unzip nano && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8 && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /build

RUN \
  cd /build && \
  curl -LO https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run

RUN \
  cd /build && \
  sh ./$(basename "$CUDA_TOOLKIT_URL") --silent --toolkit --no-drm && \
  rm ./$(basename "$CUDA_TOOLKIT_URL")

ENV ETHMINER_GIT_BRANCH=master

RUN \
  cd /build && \
  git clone ${ETHMINER_GIT_URL} && \
  cd ./ethminer && \
  git checkout ${ETHMINER_GIT_BRANCH} && \
  mkdir ./build

RUN \
  cd /build/ethminer/build && \
  cmake -DETHASHCUDA=ON -DETHASHCUDA=ON -DETHSTRATUM=ON .. && \
  cmake --build .

