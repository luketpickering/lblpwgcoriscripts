#!/bin/bash

TIME=1
RESERVATION=""
NUMPROCS=34
NUMTHRDS=2

# for sample_syst in fd,allsyst ndfd,allsyst fd,nosyst
for sample_syst in fd,allsyst ndfd,allsyst; do
  SAMPLE=$(echo ${sample_syst} | cut -d "," -f 1)
  SYSTLIST=$(echo ${sample_syst} | cut -d "," -f 2)

  for EXPOSURE in 7year 10year 15year; do
    SAMPLE="${SAMPLE}:${EXPOSURE}"

    PEN="nopen"
    PLOTVARS="deltapi:th13"

    for ASMV_SET in "deltapi:-pi/2" "deltapi:0" "deltapi:+pi/2"; do

      SYSTLIST_SANIT=$(echo $SYSTLIST | tr ':' '_' | tr '=' '-')
      ASMV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
      PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
      SAMPLE_SANIT=$(echo $SAMPLE | tr ':' '_')
      JOBNAME="KNL_${PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${ASMV_SET_SANIT}"

      ./configure_asimov_master.sh \
        -T ${TIME} \
        -K \
        -q regular -R "${RESERVATION}" \
        -N 6 \
        -n ${NUMPROCS} \
        --num-omp-threads ${NUMTHRDS} \
        -P ${PLOTVARS} \
        -S ${SYSTLIST} \
        -e ${SAMPLE} \
        -p ${PEN} \
        -h 1 \
        -a ${ASMV_SET} \
        -J ${JOBNAME}
    done

    for PEN in nopen th13; do

      PLOTVARS="deltapi:ssth23"
      for ASMV_SET in "deltapi:-pi/2,ssth23:0.42" \
                      "deltapi:0,ssth23:0.42"\
                      "deltapi:+pi/2,ssth23:0.42" \
                      "deltapi:-pi/2,ssth23:0.5"\
                      "deltapi:0,ssth23:0.5" \
                      "deltapi:+pi/2,ssth23:0.5" \
                      "deltapi:-pi/2,ssth23:0.58"\
                      "deltapi:0,ssth23:0.58" \
                      "deltapi:+pi/2,ssth23:0.58"; do

      SYSTLIST_SANIT=$(echo $SYSTLIST | tr ':' '_' | tr '=' '-')
      ASMV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
      PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
      SAMPLE_SANIT=$(echo $SAMPLE | tr ':' '_')
      JOBNAME="KNL_${PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${ASMV_SET_SANIT}"

      ./configure_asimov_master.sh \
        -T ${TIME} \
        -K \
        -q regular -R "${RESERVATION}" \
        -N 6 \
        -n ${NUMPROCS} \
        --num-omp-threads ${NUMTHRDS} \
        -P ${PLOTVARS} \
        -S ${SYSTLIST} \
        -e ${SAMPLE} \
        -p ${PEN} \
        -h 1 \
        -a ${ASMV_SET} \
        -J ${JOBNAME}

      done

      PLOTVARS="ssth23:dmsq32"
      for ASMV_SET in "ssth23:0.42" \
                      "ssth23:0.5"\
                      "ssth23:0.58"; do

      SYSTLIST_SANIT=$(echo $SYSTLIST | tr ':' '_' | tr '=' '-')
      ASMV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
      PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
      SAMPLE_SANIT=$(echo $SAMPLE | tr ':' '_')
      JOBNAME="KNL_${PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${ASMV_SET_SANIT}"

      ./configure_asimov_master.sh \
        -T ${TIME} \
        -K \
        -q regular -R "${RESERVATION}" \
        -N 6 \
        -n ${NUMPROCS} \
        --num-omp-threads ${NUMTHRDS} \
        -P ${PLOTVARS} \
        -S ${SYSTLIST} \
        -e ${SAMPLE} \
        -p ${PEN} \
        -h 1 \
        -a ${ASMV_SET} \
        -J ${JOBNAME}

      done

    done

  done
done
