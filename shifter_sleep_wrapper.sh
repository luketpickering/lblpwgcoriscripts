#!/bin/bash

#Shift these off so that the args are the same as run_throws.sh gets
IMG=${1}
shift
SCRIPT=${1}
shift

CAFEEXE=${1}
TIME_REQ_M=${2}
UNITSAFETIME_M=${3}
OUTDIR=${4}
SYSTLIST=${5}
SAMPLELIST=${6}
THROWTYPE=${7}
PENALTY=${8}
HIERARCHY=${9}
OSCVARS=${10}
SEED_START=${11}

echo "[VARINFo]: IMG: ${IMG}"
echo "[VARINFo]: SCRIPT: ${SCRIPT}"
echo "[VARINFo]: CAFEEXE: ${CAFEEXE}"
echo "[VARINFo]: TIME_REQ_M: ${TIME_REQ_M}"
echo "[VARINFo]: UNITSAFETIME_M: ${UNITSAFETIME_M}"
echo "[VARINFo]: OUTDIR: ${OUTDIR}"
echo "[VARINFo]: SYSTLIST: ${SYSTLIST}"
echo "[VARINFo]: SAMPLELIST: ${SAMPLELIST}"
echo "[VARINFo]: THROWTYPE: ${THROWTYPE}"
echo "[VARINFo]: PENALTY: ${PENALTY}"
echo "[VARINFo]: HIERARCHY: ${HIERARCHY}"
echo "[VARINFo]: OSCVARS: ${OSCVARS}"
echo "[VARINFo]: SEED_START: ${SEED_START}"

if [ -z ${SLURM_JOB_ID} ]; then
  export SLURM_JOB_ID=0
fi

if [ -z ${SLURM_PROCID} ]; then
  export SLURM_PROCID=0
fi

#When debugging don't bother checkpointing
if [ -z ${SLURM_LOCALID} ]; then
  export SLURM_LOCALID=1
fi

if [ -z ${SLURM_NODEID} ]; then
  export SLURM_NODEID=0
fi

if [ -z ${SLURM_ARRAY_TASK_ID} ]; then
  export SLURM_ARRAY_TASK_ID=0
fi

#Jobs
SLEEP_RANGE_MS=200
SLEEPTIME_WIDE_MS=$(( (SLURM_ARRAY_TASK_ID + SLURM_NODEID) * SLEEP_RANGE_MS ))
SLEEPTIME_FINE_MS=$(python -c "import random;print random.randint(0,${SLEEP_RANGE_MS})")
SLEEPTIME_S=$(python -c "print (${SLEEPTIME_WIDE_MS} + ${SLEEPTIME_FINE_MS})*1E-3;")

echo "[INFO]: Sleeping for ${SLEEPTIME_S} s: PROCID: ${SLURM_PROCID}, ARRAYID: ${SLURM_ARRAY_TASK_ID} of job: ${SLURM_JOB_ID} on node: ${SLURM_NODEID} with local ID: ${SLURM_LOCALID} @ $(date '+%Y_%m_%d-%H_%M_%S')"

sleep ${SLEEPTIME_S}

echo "[INFO]: Executing work unit @ $(date '+%Y_%m_%d-%H_%M_%S') from $(pwd)"

shifter \
  --module=none \
  --volume="/global/project:/project" \
  --image=${IMG} \
  ${SCRIPT} ${CAFEEXE} ${TIME_REQ_M} ${UNITSAFETIME_M} ${OUTDIR} ${SYSTLIST} ${SAMPLELIST} ${THROWTYPE} ${PENALTY} ${HIERARCHY} ${OSCVARS} ${SEED_START}
