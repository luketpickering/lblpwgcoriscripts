#!/bin/bash

OUTPUTDIR=/project/projectdirs/dune/users/${RUNUSER}/CAFAnaJobAsimovOutput/

mkdir -p ${OUTPUTDIR}

function check(){

  OUTDIR=${1}
  EXPOSURE=${2}
  PVARS=${3}
  ASMV=${4}

  ASMV_DIRNAME=$(echo ${ASMV} | sed "s/+pi/ppi/g" | sed "s/-pi/mpi/g" | sed "s/-/_/g"  | sed "s/,/__/g" | sed "s/\./_/g")

  NJOBDIRS=$(ls ${OUTDIR}/* | wc -l)
  if [ ${NJOBDIRS} != "1" ]; then
    echo "Found odd number of directories: ls ${OUTDIR}/*"
    return 1
  fi

  NROOTFILES=$(ls ${OUTDIR}/*/*/*.root 2>/dev/null | wc -l)
  echo "Found ${NROOTFILES} root files for ${EXPOSURE}, ${PVARS}, ${ASMV_DIRNAME}"
  if [ ${NROOTFILES} -gt 0 ]; then
    hadd -k ${OUTPUTDIR}/${PVARS}_${EXPOSURE}_${ASMV_DIRNAME}.root ${OUTDIR}/*/*/*.root
  fi

}

RUNUSER=marshalc
HIERARCHY=1

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
      SAMPLE_SANIT=$(echo $SAMPLE | tr ':' '_')
      ASIMOV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_')
      PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_')

      JN_ASMV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
      JN_PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
      JOBNAME="KNL_${JN_PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${JN_ASMV_SET_SANIT}"
      JOBNAME_SANIT=$(echo $JOBNAME | tr ' ' '_')

      OUTPUTDIR=/project/projectdirs/dune/users/${RUNUSER}/CAFAnaJobOutput/${JOBNAME_SANIT}/plot_${PLOTVARS_SANIT}/asimov_${ASIMOV_SET_SANIT}/syst_${SYSTLIST_SANIT}/samp_${SAMPLE_SANIT}/pen_${PEN}/hie_${HIERARCHY}

      check ${OUTPUTDIR} ${EXPOSURE} ${PLOTVARS_SANIT} ${ASIMOV_SET_SANIT}

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
        SAMPLE_SANIT=$(echo $SAMPLE | tr ':' '_')
        ASIMOV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_')
        PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_')

        JN_ASMV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
        JN_PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
        JOBNAME="KNL_${JN_PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${JN_ASMV_SET_SANIT}"
        JOBNAME_SANIT=$(echo $JOBNAME | tr ' ' '_')

        OUTPUTDIR=/project/projectdirs/dune/users/${RUNUSER}/CAFAnaJobOutput/${JOBNAME_SANIT}/plot_${PLOTVARS_SANIT}/asimov_${ASIMOV_SET_SANIT}/syst_${SYSTLIST_SANIT}/samp_${SAMPLE_SANIT}/pen_${PEN}/hie_${HIERARCHY}

        check ${OUTPUTDIR} ${EXPOSURE} ${PLOTVARS_SANIT} ${ASIMOV_SET_SANIT}

      done

      PLOTVARS="ssth23:dmsq32"
      for ASMV_SET in "ssth23:0.42" \
                      "ssth23:0.5"\
                      "ssth23:0.58"; do

        SYSTLIST_SANIT=$(echo $SYSTLIST | tr ':' '_' | tr '=' '-')
        SAMPLE_SANIT=$(echo $SAMPLE | tr ':' '_')
        ASIMOV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_')
        PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_')

        JN_ASMV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
        JN_PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_' | sed 's/deltapi/dp/g')
        JOBNAME="KNL_${JN_PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${JN_ASMV_SET_SANIT}"
        JOBNAME_SANIT=$(echo $JOBNAME | tr ' ' '_')

        OUTPUTDIR=/project/projectdirs/dune/users/${RUNUSER}/CAFAnaJobOutput/${JOBNAME_SANIT}/plot_${PLOTVARS_SANIT}/asimov_${ASIMOV_SET_SANIT}/syst_${SYSTLIST_SANIT}/samp_${SAMPLE_SANIT}/pen_${PEN}/hie_${HIERARCHY}

        check ${OUTPUTDIR} ${EXPOSURE} ${PLOTVARS_SANIT} ${ASIMOV_SET_SANIT}

      done

    done

  done
done
