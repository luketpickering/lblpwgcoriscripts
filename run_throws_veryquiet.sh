#!/bin/bash

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

#Checkpoint 10 times per job.
CHKSCRIPT_FREQ_S=$(( TIME_REQ_M * 6 ))

# Write all output straight to the shared memory filesystem
TMPDIR=/dev/shm
#Can use your projectdir for debugging, but will be problematic at scale
#TMPDIR=/project/projectdirs/dune/users/${USER}/jobtmp
JOBTMP=${TMPDIR}/${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}
NODETMP=${JOBTMP}/n_${SLURM_NODEID}

mkdir -p ${NODETMP}

LOGFILE=/dev/null
FITFILE=${NODETMP}/fit_${SLURM_LOCALID}.root

#Checkpointing settings:
export CAFANA_TOTALDURATION_MIN=${TIME_REQ_M}
export CAFANA_CHKDURATION_MIN=$(( CAFANA_TOTALDURATION_MIN / 20 ))
export CAFANA_SAFEUNITDURATION_MIN=${UNITSAFETIME_M}
export CAFANA_CHK_SEMAPHORE=${NODETMP}/hadd.smph

STATESTUB="/statefiles/State"

#We use the timing so just set this to 1
NTHROWS=1

# Environment is already set up in the container already

EXENAME="${CAFEEXE}_fixed_seed"

#This script should be checkpointing
if [ "${SLURM_LOCALID}" == "0" ]; then
     cp checkpoint.sh ${NODETMP}/
    ${NODETMP}/checkpoint.sh ${EXENAME} ${CHKSCRIPT_FREQ_S} ${OUTDIR} ${NODETMP} >${LOGFILE} 2>&1 &
fi

# Add one to the seed so that the first proc has seed == 1 (seed of 0 uses the time)
if [ -z ${SLURM_ARRAY_TASK_ID} ]; then
  export SLURM_ARRAY_TASK_ID=0
fi

SEED=$(( ( SLURM_ARRAY_TASK_ID * 10000 ) + SLURM_PROCID + 1 ))

if [ "${EXENAME}" == "make_all_throws_fixed_seed" ]; then

  OPTS="${SEED} ${STATESTUB} ${FITFILE} ${NTHROWS} ${SYSTLIST} ${SAMPLELIST} ${THROWTYPE} ${PENALTY} ${HIERARCHY}"

  make_all_throws_fixed_seed ${OPTS} >${LOGFILE} 2>&1

elif [ "${EXENAME}" == "make_toy_throws_fixed_seed" ]; then

  #Only matters for limited osc parameter throws, always start from NuFit4
  ASIMOV_SET="0"

  OPTS="${SEED} ${STATESTUB} ${FITFILE} ${NTHROWS} ${SYSTLIST} ${SAMPLELIST} ${THROWTYPE} ${PENALTY} ${HIERARCHY} ${ASIMOV_SET} ${OSCVARS}"

  make_toy_throws_fixed_seed ${OPTS} >${LOGFILE} 2>&1

fi

wait
