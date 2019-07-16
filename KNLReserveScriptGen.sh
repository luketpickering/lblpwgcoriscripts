#!/bin/bash

TIME=48
RESERVATION=dunelbl
NUMPROCS=60
NUMTHRDS=2
SAFETIME=250

## 7 Year, no penalty
./configure_throws_master.sh \
  -T ${TIME} -K \
  -q regular \
  -R ${RESERVATION} \
  -N 250 -n ${NUMPROCS} --num-omp-threads ${NUMTHRDS} \
  -S allsyst \
  -e ndfd:7year \
  -p nopen \
  -h 1 -O alloscvars \
  -U ${SAFETIME} \
  -J KNLRSRV_7yr_np \
  -E make_all_throws \
  --seed-start 11000000

## 7 Year, th13 penalty
./configure_throws_master.sh \
  -T ${TIME} -K \
  -q regular \
  -R ${RESERVATION} \
  -N 550 -n ${NUMPROCS} --num-omp-threads ${NUMTHRDS} \
  -S allsyst \
  -e ndfd:7year \
  -p th13 \
  -h 1 -O alloscvars \
  -U ${SAFETIME} \
  -J KNLRSRV_7yr_th13 \
  -E make_all_throws \
  --seed-start 12000000

## 10 Year, no penalty
./configure_throws_master.sh \
  -T ${TIME} -K \
  -q regular \
  -R ${RESERVATION} \
  -N 300 -n ${NUMPROCS} --num-omp-threads ${NUMTHRDS} \
  -S allsyst \
  -e ndfd:10year \
  -p nopen \
  -h 1 -O alloscvars \
  -U ${SAFETIME} \
  -J KNLRSRV_10yr_np \
  -E make_all_throws \
  --seed-start 13000000

## 10 Year, th13 penalty
./configure_throws_master.sh \
  -T ${TIME} -K \
  -q regular \
  -R ${RESERVATION} \
  -N 300 -n ${NUMPROCS} --num-omp-threads ${NUMTHRDS} \
  -S allsyst \
  -e ndfd:10year \
  -p th13 \
  -h 1 -O alloscvars \
  -U ${SAFETIME} \
  -J KNLRSRV_10yr_th13 \
  -E make_all_throws \
  --seed-start 14000000


## 15 Year, no penalty
./configure_throws_master.sh \
  -T ${TIME} -K \
  -q regular \
  -R ${RESERVATION} \
  -N 350 -n ${NUMPROCS} --num-omp-threads ${NUMTHRDS} \
  -S allsyst \
  -e ndfd:15year \
  -p nopen \
  -h 1 -O alloscvars \
  -U ${SAFETIME} \
  -J KNLRSRV_15yr_np \
  -E make_all_throws \
  --seed-start 15000000

## 15 Year, th13 penalty
./configure_throws_master.sh \
  -T ${TIME} -K \
  -q regular \
  -R ${RESERVATION} \
  -N 350 -n ${NUMPROCS} --num-omp-threads ${NUMTHRDS} \
  -S allsyst \
  -e ndfd:15year \
  -p th13 \
  -h 1 -O alloscvars \
  -U ${SAFETIME} \
  -J KNLRSRV_15yr_th13 \
  -E make_all_throws \
  --seed-start 16000000

## 10 Year, th13 penalty, Inverted hierarchy
./configure_throws_master.sh \
  -T ${TIME} -K \
  -q regular \
  -R ${RESERVATION} \
  -N 825 -n ${NUMPROCS} --num-omp-threads ${NUMTHRDS} \
  -S allsyst \
  -e ndfd:10year \
  -p th13 \
  -h -1 -O alloscvars \
  -U ${SAFETIME} \
  -J KNLRSRV_10yr_th13_IH \
  -E make_all_throws \
  --seed-start 17000000
