#!/bin/bash

declare -A OPTS

OPTS[QOS]="standard"
OPTS[TIME_REQ_H]="24"
OPTS[TIME_REQ_EM]="00"
OPTS[TIME_REQ_M]=$(( OPTS[TIME_REQ_H] * 60))
OPTS[NNODES]=1
OPTS[SYSTLIST]="allsyst"
OPTS[SAMPLELIST]="ndfd"
OPTS[PENALTY]="th13"
OPTS[HIERARCHY]="1"
OPTS[UNITSAFETIME_M]=75
OPTS[TASKSPERNODE]=64
OPTS[OSCVARS]="alloscvars"
OPTS[JOBNAME]="CAFAna_Throws"
OPTS[CAFEEXE]="make_all_throws"
OPTS[NTHREADS]="1"
OPTS[USEVQUIET]="0"
OPTS[ARRAYCMD]=""
OPTS[USEWRAPPER]="0"
OPTS[SEED_START]="0"

OUTPUTNAME="throws_master.sh"

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

      --num-omp-threads)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[NTHREADS]="$2"
        if [ ${OPTS[NTHREADS]} -gt 4 ]; then
          echo "[ERROR]: A maximum of 4 threads can be requested per job."
          exit 1
        fi
        echo "[OPT]: Each task will use ${OPTS[NTHREADS]} OMP threads."; shift # past argument
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

      -O|--oscvars)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[OSCVARS]="$2"
        echo "[OPT]: Will run jobs with oscvar string=\"${OPTS[OSCVARS]}\"."; shift # past argument
      ;;

      -U|--safe-unit-m)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[UNITSAFETIME_M]="$2"
        echo "[OPT]: Will stop running processing units if less than \"${OPTS[UNITSAFETIME_M]}\" minutes left in allocation."; shift # past argument
      ;;

      -J|--job-name)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[JOBNAME]="$2"
        echo "[OPT]: Will name job = \"${OPTS[JOBNAME]}\"."; shift # past argument
      ;;

      -E|--exe)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[CAFEEXE]="$2"
        if [ "${OPTS[CAFEEXE]}" != "make_all_throws" ] && [ "${OPTS[CAFEEXE]}" != "make_toy_throws" ]; then
          echo "[ERROR]: Passed argument to --exe ${OPTS[CAFEEXE]}, but expected \"make_all_throws\" or \"make_toy_throws\""
          exit 1
        fi
        echo "[OPT]: Will use executable = \"${OPTS[CAFEEXE]}\"."; shift # past argument
      ;;

      -Q|--very-quiet)
        OPTS[USEVQUIET]="1"
        echo "[OPT]: Will use very quiet node script."
      ;;

      -W|--use-wrapper)
        OPTS[USEWRAPPER]="1"
        echo "[OPT]: Will use wrapper node script with short intro sleep."
      ;;

      --seed-start)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        FIRST_SEED="$2"
        OPTS[SEED_START]="$(( FIRST_SEED - 1 ))"
        echo "[OPT]: Will start proc seeds from \"$FIRST_SEED}\"."; shift # past argument
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
      echo -e "\t--num-omp-threads   : Number of OMP threads to use (<=4)."
      echo -e "\t-S|--systlist       : Systematic list specifier: default =\"allsyst\""
      echo -e "\t-e|--samplelist     : Sample and exposure specifier: default = \"ndfd\""
      echo -e "\t-p|--penalty        : Oscillation penalty specifier: default = \"th13\""
      echo -e "\t-h|--hierarchy      : Hierarchy specifier: default = \"1\""
      echo -e "\t-O|--oscvars        : Osc var string: default = \"alloscvars\"."
      echo -e "\t-U|--safe-unit-m    : Estimated long fit time in minutes: default = \"75\""
      echo -e "\t-J|--job-name       : Name of the job as seen by SLURM and used in output dir structure (default = \"CAFAna_Throws\")."
      echo -e "\t-E|--exe            : Name of the executable to use, can be either \"make_all_throws\" or \"make_toy_throws\". (default = \"make_all_throws\")."
      echo -e "\t-Q|--very-quiet     : Use version of node script that redirects output to /dev/null."
      echo -e "\t-W|--use-wrapper    : Use version of srun command that calls a shifter wrapper script to sleep before starting to reduce pressure on the shifter image server."
      echo -e "\t--seed-start        : Start process seeds from this number rather than always starting from 1."
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

cat throws_master.sh.in > configuring.throws_master.sh.in
for i in QOS TIME_REQ_EM TIME_REQ_M TIME_REQ_H NNODES TASKSPERNODE SYSTLIST SAMPLELIST PENALTY HIERARCHY OSCVARS UNITSAFETIME_M JOBNAME CAFEEXE NTHREADS USEVQUIET ARRAYCMD USEWRAPPER SEED_START; do
  sed -i "s/__${i}__/${OPTS[${i}]}/g" configuring.throws_master.sh.in
done

mv configuring.throws_master.sh.in ${OUTPUTNAME}
