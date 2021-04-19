#!/bin/sh

(
cd ..
./fluent-bit/fluent-bit-1.6.6/build/bin/fluent-bit -c fluent-bit/conf/fluent-bit.conf
)
exit 0
