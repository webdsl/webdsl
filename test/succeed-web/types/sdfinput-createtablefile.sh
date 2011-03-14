#!/bin/sh

pack-sdf -i sdfinputexamplelang.sdf -o sdfinputexamplelang.def
sdf2table -i sdfinputexamplelang.def -o sdfinputexamplelang.tbl -m sdfinputexamplelang
rm sdfinputexamplelang.def