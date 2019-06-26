#!/bin/bash

TIME_REQ_M=$1
OUTDIR=$2
SYSTLIST=$3
SAMPLELIST=$4
THROWTYPE=$5
PENALTY=$6
HIERARCHY=$7

TMPDIR=/dev/shm
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

# Add one to the seed so that the first proc has seed == 1 (seed of 0 uses the time)
SEED=$(( SLURM_PROCID + 1 ))

OPTS="${SLURM_PROCID} ${STATESTUB} ${FITFILE} ${NTHROWS} ${SYSTLIST} ${SAMPLELIST} ${THROWTYPE} ${PENALTY} ${HIERARCHY}"
echo "[DEBUG]: Sourcing environment @ $(date '+%Y_%m_%d-%H_%M_%S')" 2>&1 | tee -a ${LOGFILE}
source /opt/CAFAna/CAFAnaEnv.sh 2>&1 | tee -a ${LOGFILE}

echo "[INFO]: df -h ${TMPDIR}" | tee -a ${LOGFILE}
df -h ${TMPDIR} | tee -a ${LOGFILE}


export CAFANA_TOTALDURATION_MIN=${TIME_REQ_M}
export CAFANA_CHKDURATION_MIN=$(( TIME_REQ_M / 10 ))
export CAFANA_SAFEUNITDURATION_MIN=75
export CAFANA_CHK_SEMAPHORE=${NODETMP}/hadd.smph

CHKSCRIPT_FREQ_S=$(( CAFANA_CHKDURATION_MIN * 60 ))

echo "[DEBUG]: CHK: CAFANA_TOTALDURATION_MIN=${CAFANA_TOTALDURATION_MIN}, CAFANA_CHKDURATION_MIN=${CAFANA_CHKDURATION_MIN}" 2>&1 | tee -a ${LOGFILE}
echo "[DEBUG]: CHK: CAFANA_SAFEUNITDURATION_MIN=${CAFANA_SAFEUNITDURATION_MIN}, CAFANA_CHK_SEMAPHORE=${CAFANA_CHK_SEMAPHORE}" 2>&1 | tee -a ${LOGFILE}


if [ "${SLURM_LOCALID}" == "0" ]; then
     echo "I am local id 0, backgrounding checkpointing script which should wake up ever ${CHKSCRIPT_FREQ_S} s." 2>&1 | tee -a ${LOGFILE}
    ./checkpoint.sh ${CHKSCRIPT_FREQ_S} ${OUTDIR} ${NODETMP} > >(tee -a ${LOGFILE}) 2>&1 &
fi

echo "make_all_throws_fixed_seed ${OPTS} @ $(date '+%Y_%m_%d-%H_%M_%S')" 2>&1 | tee -a ${LOGFILE}
make_all_throws_fixed_seed ${OPTS} 2>&1 | tee -a ${LOGFILE}
echo "DONE @ $(date '+%Y_%m_%d-%H_%M_%S')" | tee -a ${LOGFILE}

#Don't end the script until checkpoint is done
if [ "${SLURM_LOCALID}" == "0" ]; then
  echo "[INFO]: Waiting on checkpoint.sh" | tee -a ${LOGFILE}
  jobs | tee -a ${LOGFILE}
fi

wait
