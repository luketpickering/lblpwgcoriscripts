#!/bin/bash

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

#Checkpointing settings:
export CAFANA_TOTALDURATION_MIN=${TIME_REQ_M}
export CAFANA_CHKDURATION_MIN=60
export CAFANA_SAFEUNITDURATION_MIN=${UNITSAFE_M}
export CAFANA_CHK_SEMAPHORE=${NODETMP}/hadd.smph

#Checkpoint every half an hour, check NProcs every 3 mins.
CHKSCRIPT_FREQ_S=$(( 30 * 60 ))

# Write all output straight to the shared memory filesystem
TMPDIR=/dev/shm
#Can use your projectdir for debugging, but will be problematic at scale
#TMPDIR=/project/projectdirs/dune/users/${USER}/jobtmp
JOBTMP=${TMPDIR}/${SLURM_JOB_ID}
NODETMP=${JOBTMP}/n_${SLURM_NODEID}

mkdir -p ${NODETMP}

LOGFILE=${NODETMP}/job_${SLURM_JOB_ID}_n${SLURM_NODEID}_l${SLURM_LOCALID}.log
FITFILE=${NODETMP}/fit_${SLURM_LOCALID}.root

echo "Running process ${SLURM_PROCID} of job ${SLURM_JOB_ID} on node ${SLURM_NODEID} local ID ${SLURM_LOCALID} @ $(date '+%Y_%m_%d-%H_%M_%S')" 2>&1 | tee ${LOGFILE}

STATESTUB="/statefiles/State"

#We use the timing so just set this to 1
NTHROWS=1

echo "[DEBUG]: Sourcing environment @ $(date '+%Y_%m_%d-%H_%M_%S')" 2>&1 | tee -a ${LOGFILE}
source /opt/CAFAna/CAFAnaEnv.sh 2>&1 | tee -a ${LOGFILE}
printenv |  tee -a ${LOGFILE}

echo "[INFO]: df -h ${TMPDIR}" | tee -a ${LOGFILE}
df -h ${TMPDIR} | tee -a ${LOGFILE}

echo "[DEBUG]: CHK: CAFANA_TOTALDURATION_MIN=${CAFANA_TOTALDURATION_MIN}, CAFANA_CHKDURATION_MIN=${CAFANA_CHKDURATION_MIN}" 2>&1 | tee -a ${LOGFILE}
echo "[DEBUG]: CHK: CAFANA_SAFEUNITDURATION_MIN=${CAFANA_SAFEUNITDURATION_MIN}, CAFANA_CHK_SEMAPHORE=${CAFANA_CHK_SEMAPHORE}" 2>&1 | tee -a ${LOGFILE}

EXENAME="${CAFEEXE}_fixed_seed"
echo "[DEBUG]: Running ${EXENAME}"

#This script should be checkpointing
if [ "${SLURM_LOCALID}" == "0" ]; then
     echo "[CHK-INFO]: I am local id 0, backgrounding checkpointing script which should wake up every ${CHKSCRIPT_FREQ_S} s." 2>&1 | tee -a ${LOGFILE}
     cp checkpoint.sh ${NODETMP}/
    ${NODETMP}/checkpoint.sh ${EXENAME} ${CHKSCRIPT_FREQ_S} ${OUTDIR} ${NODETMP} > >(tee -a ${LOGFILE}) 2>&1 &
fi

# Add one to the seed so that the first proc has seed == 1 (seed of 0 uses the time)
SEED=$(( SLURM_PROCID + 1 ))
echo "[DEBUG]: Seed = ${SEED}"

if [ "${EXENAME}" == "make_all_throws_fixed_seed" ]; then

  OPTS="${SEED} ${STATESTUB} ${FITFILE} ${NTHROWS} ${SYSTLIST} ${SAMPLELIST} ${THROWTYPE} ${PENALTY} ${HIERARCHY}"

  echo "[RUN]: make_all_fixed_seed ${OPTS} @ $(date '+%Y_%m_%d-%H_%M_%S')" 2>&1 | tee -a ${LOGFILE}
  make_all_fixed_seed ${OPTS} 2>&1 | tee -a ${LOGFILE}

elif [ "${EXENAME}" == "make_toy_throws_fixed_seed" ]; then

  #Only matters for limited osc parameter throws, always start from NuFit4
  ASIMOV_SET="0"

  OPTS="${SEED} ${STATESTUB} ${FITFILE} ${NTHROWS} ${SYSTLIST} ${SAMPLELIST} ${THROWTYPE} ${PENALTY} ${HIERARCHY} ${ASIMOV_SET} ${OSCVARS}"

  echo "[RUN]: make_toy_throws_fixed_seed ${OPTS} @ $(date '+%Y_%m_%d-%H_%M_%S')" 2>&1 | tee -a ${LOGFILE}
  make_toy_throws_fixed_seed ${OPTS} 2>&1 | tee -a ${LOGFILE}

fi

echo "DONE @ $(date '+%Y_%m_%d-%H_%M_%S')" | tee -a ${LOGFILE}


#Don't end the script until checkpoint is done
if [ "${SLURM_LOCALID}" == "0" ]; then
  echo "[INFO]: Waiting on checkpoint.sh" | tee -a ${LOGFILE}
  jobs | tee -a ${LOGFILE}
fi

wait
