#!/bin/bash

declare -A OPTS

OPTS[QOS]="regular"
OPTS[TIME_REQ_H]="24"
OPTS[TIME_REQ_EM]="00"
OPTS[TIME_REQ_M]=$(( OPTS[TIME_REQ_H] * 60 ))
OPTS[NNODES]=1
OPTS[PLOTVARS]="deltapi:th13"
OPTS[SYSTLIST]="allsyst"
OPTS[SAMPLELIST]="ndfd"
OPTS[PENALTY]="th13"
OPTS[HIERARCHY]="1"
OPTS[ASIMOV_SET]="deltapi:-pi/2"
OPTS[TASKSPERNODE]=34
OPTS[JOBNAME]="CAFAna_Asimov"
OPTS[NTHREADS]="2"
OPTS[ARRAYCMD]=""
OPTS[CONSTRAINT]="haswell"
OPTS[IMAGE]="picker24/dune_cafana:SLS_wsf_wdeps_b3df9d6"
OPTS[RESERVECMD]=""

OUTPUTNAME="asimov_master.sh"

while [[ ${#} -gt 0 ]]; do
  key="$1"
  case $key in

      -T|--time-req-h)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[TIME_REQ_H]="$2"
        echo "[OPT]: Requesting ${OPTS[TIME_REQ_H]} hours."; shift # past argument
      ;;

      -q|--qos)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[QOS]="$2"
        echo "[OPT]: Requsting allocation in ${OPTS[QOS]} queue."; shift # past argument
      ;;

      -N|--nodes)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[NNODES]="$2"
        echo "[OPT]: Requsting ${OPTS[NNODES]} nodes."; shift # past argument
      ;;

      -n|--tasks-per-node)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[TASKSPERNODE]="$2"
        echo "[OPT]: Requsting ${OPTS[TASKSPERNODE]} tasks per node."; shift # past argument
      ;;

      -A|--array-tasks)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        NARR=$2
        #remove one as it asks for a 0-index array specifier
        OPTS[ARRAYCMD]="#SBATCH --array=0-$(( NARR - 1 ))"
        echo "[OPT]: Requsting ${NARR} instances of the job."; shift # past argument
      ;;

      -R|--reservation)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        RSRV=$2
        #remove one as it asks for a 0-index array specifier
        OPTS[RESERVECMD]="#SBATCH --reservation=${RSRV}"
        echo "[OPT]: Requsting job be assigned ${RSRV} reservation."; shift # past argument
      ;;

      --num-omp-threads)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[NTHREADS]="$2"
        if [ ${OPTS[NTHREADS]} -gt 4 ]; then
          echo "[ERROR]: A maximum of 4 threads can be requested per job."
          exit 1
        fi
        echo "[OPT]: Each task will use ${OPTS[NTHREADS]} OMP threads."; shift # past argument
      ;;

      -P|--plot-variables)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[PLOTVARS]="$2"
        echo "[OPT]: Will run \"${OPTS[PLOTVARS]}\" asimov jobs."; shift # past argument
      ;;

      -S|--systlist)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[SYSTLIST]="$2"
        echo "[OPT]: Will run \"${OPTS[SYSTLIST]}\" jobs."; shift # past argument
      ;;

      -e|--samplelist)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[SAMPLELIST]="$2"
        echo "[OPT]: Will run \"${OPTS[SAMPLELIST]}\" jobs."; shift # past argument
      ;;

      -p|--penalty)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[PENALTY]="$2"
        echo "[OPT]: Will run jobs with: \"${OPTS[PENALTY]}\"."; shift # past argument
      ;;

      -h|--hierarchy)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[HIERARCHY]="$2"
        echo "[OPT]: Will run jobs with hierarchy=\"${OPTS[HIERARCHY]}\"."; shift # past argument
      ;;

      -a|--asimov-set)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[ASIMOV_SET]="$2"
        echo "[OPT]: Will run jobs with asimov set string=\"${OPTS[ASIMOV_SET]}\"."; shift # past argument
      ;;

      -J|--job-name)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[JOBNAME]="$2"
        OUTPUTNAME="${2}.sh"
        echo "[OPT]: Will name job = \"${OPTS[JOBNAME]}\"."; shift # past argument
      ;;

      -I|--image)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[IMAGE]="$2"
        echo "[OPT]: Will run jobs with image=\"${OPTS[IMAGE]}\"."; shift # past argument
      ;;

      -K|--use-knl)
        OPTS[CONSTRAINT]="knl"
        echo "[OPT]: Will use knl nodes."
      ;;

      -o|--output)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OUTPUTNAME="$2"
        echo "[OPT]: Will write configured script to \"${OUTPUTNAME}\"."; shift # past argument
      ;;

      -?|--help)
      echo "[RUNLIKE] ${SCRIPTNAME}"
      echo -e "\t-T|--time-req-h     : Allocation time request in hours: default = \"24\""
      echo -e "\t-q|--qos            : Allocation partition: default = \"standard\""
      echo -e "\t-N|--nodes          : Allocation number of nodes: default = \"1\"."
      echo -e "\t-n|--tasks-per-node : Allocations number of tasks per node."
      echo -e "\t-A|--array-tasks    : Number of job instances to submit (seeds are shifted)."
      echo -e "\t-R|--reservation    : If your job should run in a reservation use this to add the SBATCH option."
      echo -e "\t--num-omp-threads   : Number of OMP threads to use (<=4)."
      echo -e "\t-P|--plot-variables : Variables to plot, default =\"deltapi:th13\""
      echo -e "\t-S|--systlist       : Systematic list specifier: default =\"allsyst\""
      echo -e "\t-e|--samplelist     : Sample and exposure specifier: default = \"ndfd\""
      echo -e "\t-p|--penalty        : Oscillation penalty specifier: default = \"th13\""
      echo -e "\t-h|--hierarchy      : Hierarchy specifier: default = \"1\""
      echo -e "\t-a|--asimov-set     : Asimov set to use, default=\"deltapi:-pi/2\"."
      echo -e "\t-J|--job-name       : Name of the job as seen by SLURM and used in output dir structure (default = \"CAFAna_Throws\")."
      echo -e "\t-K|--use-knl        : Constrain jobs to run on KNL nodes."
      echo -e "\t-I|--image          : Shifter image declaration to use."
      echo -e "\t-o|--output         : File name to write configured script to."
      echo -e "\t-?|--help           : Print this message."
      exit 0
      ;;

      *)
              # unknown option
      echo "Unknown option $1"
      exit 1
      ;;
  esac
  shift # past argument or value
done

if [ -e ${OUTPUTNAME} ]; then
  echo "[ERROR]: Refusing to overwrite existing file: \"${OUTPUTNAME}\"."
  exit 1
fi

if [[ ${OPTS[QOS]} == "debug" ]]; then
  echo "Adjusting time for debug QOS."
  OPTS[TIME_REQ_EM]=15
  OPTS[TIME_REQ_M]=15
  OPTS[TIME_REQ_H]=0
else
  OPTS[TIME_REQ_M]=$(( OPTS[TIME_REQ_H] * 60))
fi

cat asimov_master.sh.in > configuring.asimov_master.sh.in
for i in  QOS \
          TIME_REQ_H \
          TIME_REQ_EM \
          TIME_REQ_M \
          NNODES \
          PLOTVARS \
          SYSTLIST \
          SAMPLELIST \
          PENALTY \
          HIERARCHY \
          ASIMOV_SET \
          TASKSPERNODE \
          JOBNAME \
          NTHREADS \
          ARRAYCMD \
          CONSTRAINT \
          IMAGE \
          RESERVECMD; do
  sed -i "s|__${i}__|${OPTS[${i}]}|g" configuring.asimov_master.sh.in
done

mv configuring.asimov_master.sh.in ${OUTPUTNAME}
