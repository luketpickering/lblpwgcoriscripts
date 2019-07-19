#!/bin/bash

TIME=1
RESERVATION=""
NUMPROCS=34
NUMTHRDS=2

## 7 Year, no penalty
./configure_asimov_master.sh \
  -T ${TIME} \
  -K \
  -q debug \
  -N 6 \
  -n ${NUMPROCS} \
  --num-omp-threads ${NUMTHRDS} \
  -P deltapi:th13 \
  -S nosyst \
  -e ndfd:15year \
  -p th13 \
  -h 1 \
  -a deltapi:-pi/2 \
  -J KNLASMV_15yr_th13
