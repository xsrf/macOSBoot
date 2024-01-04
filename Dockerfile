FROM ubuntu:20.04

# Installing libxml2-dev will install tzdata and interactively ask for your Timezone if it's not set
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt update \
    && apt -y install build-essential autoconf hfsprogs dmg2img libssl-dev git p7zip-full p7zip-rar tzdata libxml2-dev zlib1g-dev \
    && apt clean

RUN git clone https://github.com/mackyle/xar \
    && cd xar/xar \
    && sed -i.bak 's/OpenSSL_add_all_ciphers/OPENSSL_init_crypto/g' configure.ac \
    && ./autogen.sh --prefix=/usr/local \
    && make \
    && make install \
    && cd ../../ \
    && rm -rf xar