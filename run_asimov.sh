#!/bin/bash

TIME_REQ_M=${1}
OUTDIR=${2}
PLOTVARS=${3}
SYSTLIST=${4}
SAMPLELIST=${5}
PENALTY=${6}
HIERARCHY=${7}
ASIMOV_SET=${8}

echo "[VARINFO]: TIME_REQ_M: ${TIME_REQ_M}"
echo "[VARINFO]: OUTDIR: ${OUTDIR}"
echo "[VARINFO]: PLOTVARS: ${PLOTVARS}"
echo "[VARINFO]: SYSTLIST: ${SYSTLIST}"
echo "[VARINFO]: SAMPLELIST: ${SAMPLELIST}"
echo "[VARINFO]: PENALTY: ${PENALTY}"
echo "[VARINFO]: HIERARCHY: ${HIERARCHY}"
echo "[VARINFO]: ASIMOV_SET: ${ASIMOV_SET}"

#Checkpoint 10 times per job.
CHKSCRIPT_FREQ_S=$(( TIME_REQ_M * 3 ))

# Write all output straight to the shared memory filesystem
TMPDIR=/dev/shm
#Can use your projectdir for debugging, but will be problematic at scale
#TMPDIR=/project/projectdirs/dune/users/${USER}/jobtmp
JOBTMP=${TMPDIR}/${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}
NODETMP=${JOBTMP}/n_${SLURM_NODEID}

mkdir -p ${NODETMP}

LOGFILE=${NODETMP}/job_${SLURM_JOB_ID}_a${SLURM_ARRAY_TASK_ID}_n${SLURM_NODEID}_l${SLURM_LOCALID}.log
ASMVFILE=${NODETMP}/asmv_${SLURM_LOCALID}.root

echo "Running process ${SLURM_PROCID}, array ${SLURM_ARRAY_TASK_ID} of job ${SLURM_JOB_ID} on node ${SLURM_NODEID} local ID ${SLURM_LOCALID} with ${OMP_NUM_THREADS} threads per proc @ $(date '+%Y_%m_%d-%H_%M_%S')" 2>&1 | tee ${LOGFILE}

STATESTUB="/statefiles/State"

echo "[INFO]: df -h ${TMPDIR}" | tee -a ${LOGFILE}
df -h ${TMPDIR} | tee -a ${LOGFILE}

echo "[DEBUG]: Running asimov_joint"

#This script should be checkpointing
if [ "${SLURM_LOCALID}" == "0" ]; then
     echo "[CHK-INFO]: I am local id 0, backgrounding checkfinish script which should wake up every ${CHKSCRIPT_FREQ_S} s." 2>&1 | tee -a ${LOGFILE}
     cp checkfinish.sh ${NODETMP}/
    ${NODETMP}/checkfinish.sh asimov_joint ${CHKSCRIPT_FREQ_S} ${OUTDIR} ${NODETMP} > >(tee -a ${LOGFILE}) 2>&1 &
fi

OPTS="${STATESTUB} ${ASMVFILE} ${PLOTVARS}:$(( ${SLURM_PROCID} + 1 )) ${SYSTLIST} ${SAMPLELIST} ${PENALTY} ${HIERARCHY} ${ASIMOV_SET}"

echo "[RUN]: asimov_joint ${OPTS} @ $(date '+%Y_%m_%d-%H_%M_%S')" 2>&1 | tee -a ${LOGFILE}
asimov_joint ${OPTS} 2>&1 | tee -a ${LOGFILE}

echo "DONE @ $(date '+%Y_%m_%d-%H_%M_%S')" | tee -a ${LOGFILE}

#Don't end the script until checkfinish is done
if [ "${SLURM_LOCALID}" == "0" ]; then
  echo "[INFO]: Waiting on checkfinish.sh" | tee -a ${LOGFILE}
  jobs | tee -a ${LOGFILE}
fi

wait
