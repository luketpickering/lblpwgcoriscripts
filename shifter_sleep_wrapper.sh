#!/bin/bash

#Shift these off so that the args are the same as run_throws.sh gets
IMG=${1}
shift
SCRIPT=${1}
shift

CAFEEXE=${1}
TIME_REQ_M=${2}
UNITSAFE_M=${3}
OUTDIR=${4}
SYSTLIST=${5}
SAMPLELIST=${6}
THROWTYPE=${7}
PENALTY=${8}
HIERARCHY=${9}
OSCVARS=${10}

if [ -z ${SLURM_NODEID} ]; then
  export SLURM_NODEID=0
fi

if [ -z ${SLURM_ARRAY_TASK_ID} ]; then
  export SLURM_ARRAY_TASK_ID=0
fi

#Jobs
SLEEPTIME_WIDE_S=$(( (SLURM_ARRAY_TASK_ID + SLURM_NODEID) * 20 ))
SLEEPTIME_FINE_S=$(python -c "import random;print random.randint(0,20)")
SLEEPTIME_S=$((SLEEPTIME_WIDE_S + SLEEPTIME_FINE_S))

echo "[INFO]: Sleeping for ${SLEEPTIME_S} s: ${SLURM_PROCID}, array ${SLURM_ARRAY_TASK_ID} of job ${SLURM_JOB_ID} on node ${SLURM_NODEID} local ID ${SLURM_LOCALID} @ $(date '+%Y_%m_%d-%H_%M_%S')"

sleep ${SLEEPTIME_S}

echo "[INFO]: Executing work unit @ $(date '+%Y_%m_%d-%H_%M_%S')"

shifter \
  --module=none \
  --volume="/global/project:/project" \
  --image=${IMG} \
  ${SCRIPT} ${CAFEEXE} ${TIME_REQ_M} ${UNITSAFETIME_M} ${OUTDIR} ${SYSTLIST} ${SAMPLELIST} ${THROWTYPE} ${PENALTY} ${HIERARCHY} ${OSCVARS}
