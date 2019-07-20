#!/bin/bash

EXENAME=${1}
CHECKFREQ_S=${2}
OUTDIR=${3}
NODETMP=${4}

cd ${NODETMP}

CHKFILE=chk_asmv_j${SLURM_JOB_ID}_n${SLURM_NODEID}.root

function check_live() {
  NRELPROCS=$(ps aux | grep "${EXENAME}" | grep -v "grep" | grep -v "srun" | grep -v "bash" | wc -l)
  echo "[CHK-INFO]: There are ${NRELPROCS} ${EXENAME} still running @ $(date '+%Y_%m_%d-%H_%M_%S')"
  if [ "${NRELPROCS}" == "0" ]; then
    echo "[CHK-INFO]: Finished! No processes running, cleaning up /dev/shm and bailing @ $(date '+%Y_%m_%d-%H_%M_%S')"
    rm -f ${CHKFILE}

    FILE_COUNT=$(ls -1q asmv_*.root 2>/dev/null | wc -l)
    echo "[CHK-INFO]: Found ${FILE_COUNT} output files... hadding"
    hadd -k ${CHKFILE} asmv_*.root

    mkdir -p ${OUTDIR}/
    echo "[CHK-INFO]: Copying out \"cp ${CHKFILE} ${OUTDIR}/asmv_j${SLURM_JOB_ID}_n${SLURM_NODEID}.final.root\""
    cp ${CHKFILE} ${OUTDIR}/asmv_j${SLURM_JOB_ID}_n${SLURM_NODEID}.final.root

    FILE_COUNT=$(ls -1q *.log 2>/dev/null | wc -l)
    echo "[CHK-INFO]: Copying out \"cp log_j${SLURM_JOB_ID}_n${SLURM_NODEID}.final.tar.gz ${OUTDIR}/\""
    # Tar should shut up as itz zipping up the file that its writing out to
    tar -zcf log_j${SLURM_JOB_ID}_n${SLURM_NODEID}.final.tar.gz *.log 1>/dev/null 2>&1
    cp log_j${SLURM_JOB_ID}_n${SLURM_NODEID}.final.tar.gz ${OUTDIR}/
    rm -rf ${NODETMP}
    exit 0
  fi
}

function make_checklog() {
  check_live

  cat /proc/meminfo | sed "s/^/[MEM-INFO]: /g"

  echo "[CHK-INFO]: Checking for log files @ $(date '+%Y_%m_%d-%H_%M_%S')"
  rm -f ${CHKFILE}

  FILE_COUNT=$(ls -1q *.log 2>/dev/null | wc -l)
  echo "[CHK-INFO]: Found ${FILE_COUNT} log files..."
  if [ ${FILE_COUNT} -gt 0 ]; then
    # Tar should shut up as itz zipping up the file that its writing out to
    tar -zcf log_j${SLURM_JOB_ID}_n${SLURM_NODEID}.chk_${CHK_COUNT}.tar.gz *.log 1>/dev/null 2>&1
    echo "[CHK-INFO]: Copying out \"cp log_j${SLURM_JOB_ID}_n${SLURM_NODEID}.chk_${CHK_COUNT}.tar.gz ${OUTDIR}/\""
    cp log_j${SLURM_JOB_ID}_n${SLURM_NODEID}.chk_${CHK_COUNT}.tar.gz ${OUTDIR}/
    rm -f log_j${SLURM_JOB_ID}_n${SLURM_NODEID}.chk_${CHK_COUNT}.tar.gz
  fi
  echo "[CHK-INFO]: Done checkpoint ${CHK_COUNT}"
  CHK_COUNT=$(( CHK_COUNT + 1 ))
}


DECICHECKFREQ_S=$(( CHECKFREQ_S / 20 ))
echo "[CHK-INFO]: Let's do some checkfinishing on job ${SLURM_JOB_ID} node ${SLURM_NODEID}. Checkfinishing every ${DECICHECKFREQ_S} seconds @ $(date '+%Y_%m_%d-%H_%M_%S')"
while true; do
  for i in {0..10}; do
      sleep ${DECICHECKFREQ_S}
      check_live
  done
  make_checklog
done
