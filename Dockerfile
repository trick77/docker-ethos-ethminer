FROM ubuntu:16.04

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y python build-essential mesa-common-dev g++-4.8 gcc-4.8 cmake curl wget git unzip nano && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8 && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /build

ARG CUDA_TOOLKIT_URL=https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux

RUN \
  cd /build && \
  curl -LO ${CUDA_TOOLKIT_URL}

RUN \
  cd /build && \
  sh ./$(basename "$CUDA_TOOLKIT_URL") --silent --toolkit --no-drm && \
  rm ./$(basename "$CUDA_TOOLKIT_URL")

ARG ETHMINER_GIT_URL=https://github.com/ethereum-mining/ethminer
ARG ETHMINER_GIT_BRANCH=master
ARG ETHMINER_GIT_TAG=v0.13.0rc6

RUN \
  cd /build && \
  git clone ${ETHMINER_GIT_URL} && \
  cd ./ethminer && \
  git checkout tags/${ETHMINER_GIT_TAG} && \
  mkdir ./build

RUN \
  cd /build/ethminer/build && \
  cmake -DETHASHCL=ON -DETHASHCUDA=ON -DETHSTRATUM=ON .. && \
  cmake --build .

