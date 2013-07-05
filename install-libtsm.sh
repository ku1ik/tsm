#!/bin/bash

set -e

cd /tmp
test -d ./kmscon || git clone https://github.com/dvdhrm/kmscon.git
cd kmscon
git checkout 4962213
test -f ./configure || NOCONFIGURE=1 ./autogen.sh
./configure --enable-tsm=on --enable-kmscon=off --enable-wlterm=off --enable-eloop=off --enable-uterm=off --enable-uvt=off --enable-debug=off --with-video= --with-fonts= --with-renderers= --with-sessions="terminal"
make
sudo make install
