#!/bin/bash

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
      JOBNAME="KNL_${PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${ASIMOV_SET_SANIT}"
      JOBNAME_SANIT=$(echo $JOBNAME | tr ' ' '_')

      OUTPUTDIR=/project/projectdirs/dune/users/${RUNUSER}/CAFAnaJobOutput/${JOBNAME_SANIT}/plot_${PLOTVARS_SANIT}/asimov_${ASIMOV_SET_SANIT}/syst_${SYSTLIST_SANIT}/samp_${SAMPLE_SANIT}/pen_${PEN}/hie_${HIERARCHY}/

      echo "[OUTPUTDIR]: ls $OUTPUTDIR"
      ls $OUTPUTDIR

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
        JOBNAME="KNL_${PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${ASIMOV_SET_SANIT}"
        JOBNAME_SANIT=$(echo $JOBNAME | tr ' ' '_')

        OUTPUTDIR=/project/projectdirs/dune/users/${RUNUSER}/CAFAnaJobOutput/${JOBNAME_SANIT}/plot_${PLOTVARS_SANIT}/asimov_${ASIMOV_SET_SANIT}/syst_${SYSTLIST_SANIT}/samp_${SAMPLE_SANIT}/pen_${PEN}/hie_${HIERARCHY}/

        echo "[OUTPUTDIR]: ls $OUTPUTDIR"
        ls $OUTPUTDIR

      done

      PLOTVARS="ssth23:dmsq32"
      for ASMV_SET in "ssth23:0.42" \
                      "ssth23:0.5"\
                      "ssth23:0.58"; do

        SYSTLIST_SANIT=$(echo $SYSTLIST | tr ':' '_' | tr '=' '-')
        SAMPLE_SANIT=$(echo $SAMPLE | tr ':' '_')
        ASIMOV_SET_SANIT=$(echo $ASMV_SET | tr ':' '-' | tr '/' '_')
        PLOTVARS_SANIT=$(echo $PLOTVARS | tr ':' '-' | tr '/' '_')
        JOBNAME="KNL_${PLOTVARS_SANIT}_${SYSTLIST_SANIT}_${SAMPLE_SANIT}_pen_${PEN}_${ASIMOV_SET_SANIT}"
        JOBNAME_SANIT=$(echo $JOBNAME | tr ' ' '_')

        OUTPUTDIR=/project/projectdirs/dune/users/${RUNUSER}/CAFAnaJobOutput/${JOBNAME_SANIT}/plot_${PLOTVARS_SANIT}/asimov_${ASIMOV_SET_SANIT}/syst_${SYSTLIST_SANIT}/samp_${SAMPLE_SANIT}/pen_${PEN}/hie_${HIERARCHY}/

        echo "[OUTPUTDIR]: ls $OUTPUTDIR"
        ls $OUTPUTDIR

      done

    done

  done
done
