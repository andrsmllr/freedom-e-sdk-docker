FROM ubuntu:20.04 AS freedom-e-sdk-builder
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="andrsmllr <andrsmllr@bananatronics.org>"
LABEL description="The Freedom-E-SDK for HiFives E series of RISCV processors."
LABEL version="1.1"
ARG FREEDOM_E_SDK_BRANCH=v20.05.00.02

SHELL ["/bin/bash", "-c"]
USER root:root

ENV FREEDOM_E_SDK_VERSION=${FREEDOM_E_SDK_VERSION}
ENV FREEDOM_E_SDK_SRC=/opt/freedom-e-sdk
ENV FREEDOM_E_SDK_PATH=/opt/freedom-e-sdk

# Install dependencies.
WORKDIR ${FREEDOM_E_SDK_SRC}
RUN apt update -qq \
    && apt install -qq -y \
    autoconf \
    automake \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    bison \
    flex \
    texinfo \
    libtool \
    libusb-1.0-0-dev \
    make \
    g++ \
    pkg-config \
    libexpat1-dev \
    zlib1g-dev \
    git \
    wget \
    python3 \
    python3-venv \
    libftdi1 \
    libftdi1-2 \
    && rm -rf /var/lib/apt/lists/*

# Get Freddom-E-SDK sources.
RUN git clone https://github.com/sifive/freedom-e-sdk . \
    && git checkout ${FREEDOM_E_SDK_VERSION} \
    && git submodule init \
    && git submodule update --recursive

# Get recommended compiler binaries from SiFive homepage.
ENV RISCV_PATH=/opt/riscv64-unkown-elf-gcc-8.2.0/
RUN wget -nv \
    https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14.tar.gz \
    && mkdir -p ${RISCV_PATH} \
    && tar -xf *.tar.gz \
    && rm -f ./*.tar.gz \
    && mv $(find . -maxdepth 1 -name "riscv64-unknown-elf-gcc*" -type d)/* ${RISCV_PATH} \
    && rm -rf $(find . -maxdepth 1 -name "riscv64-unknown-elf-gcc*" -type d) \
    && export PATH=$PATH:${RISCV_PATH}bin

# Get recommended OpenOCD binaries from SiFive homepage.
ENV RISCV_OPENOCD_PATH=/opt/riscv-openocd-0.10.0/
RUN wget -nv \
    https://static.dev.sifive.com/dev-tools/riscv-openocd-0.10.0-2019.05.1-x86_64-linux-ubuntu14.tar.gz \
    && mkdir -p ${RISCV_OPENOCD_PATH} \
    && tar -xf *.tar.gz \
    && rm -f ./*.tar.gz \
    && mv $(find . -maxdepth 1 -name "riscv-openocd*" -type d)/* ${RISCV_OPENOCD_PATH} \
    && rm -rf $(find . -maxdepth 1 -name "riscv-openocd*" -type d) \
    && export PATH=$PATH:${RISCV_OPENOCD_PATH}bin \
    && make

WORKDIR ${FREEDOM_E_SDK_PATH}
ENTRYPOINT ["make"]
CMD ["help"]
