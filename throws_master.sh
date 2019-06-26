#!/bin/bash
#SBATCH --account=dune
#SBATCH --qos=premium
#SBATCH --constraint=haswell
#SBATCH --nodes=1
#SBATCH --tasks-per-node=64
#SBATCH --time=1:00:00

#Job settings:
TIME_REQ_H=1
TIME_REQ_M=$(( TIME_REQ_H * 60 ))
SYSTLIST="noxsec:nodet"
SAMPLELIST="ndfd"
PENALTY="nopen"
THROWTYPE="start:stat:fake"
HIERARCHY="1"

#OpenMP settings:
export OMP_NUM_THREADS=1
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

#Output settings:
SYSTLIST_SANIT=$(echo $SYSTLIST | tr ':' '_')
export OUSERDIR=${USER}
OUTDIR=/project/projectdirs/dune/users/${OUSERDIR}/LBLAna_Output/$(date "+%Y_%m_%d-%H_%M_%S")/syst_${SYSTLIST_SANIT}/samp_${SAMPLELIST}/pen_${PENALTY}/hie_${HIERARCHY}/${SLURM_JOB_ID}
mkdir -p ${OUTDIR}
SRUNLOGFILE="${OUTDIR}/throws_%t.log"
#SRUNLOGFILE=/dev/null

echo "[INFO]: Job writing output to ${OUTDIR} and task logs to ${SRUNLOGFILE}."

#Container settings:
#debian based all deps
IMG="picker24/dune_cafana:SLS_wsf_wdeps"
#centos based cvmfs
#IMG="picker24/dune_cafana:SLS_wsf"

             # Tasks handle their own logging
srun --output=${SRUNLOGFILE} \
  --cpu_bind=cores shifter \
  --module cvmfs \
  --volume="/global/project:/project" \
  --image=${IMG} \
  ./run_throws.sh ${TIME_REQ_M} ${OUTDIR} ${SYSTLIST} ${SAMPLELIST} ${THROWTYPE} ${PENALTY} ${HIERARCHY}
