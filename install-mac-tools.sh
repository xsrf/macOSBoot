#!/bin/bash

git clone https://github.com/mackyle/xar
cd xar/xar
sed -i.bak 's/OpenSSL_add_all_ciphers/OPENSSL_init_crypto/g' configure.ac
./autogen.sh --prefix=/usr/local
make
make install
cd ../../
rm -rf xar