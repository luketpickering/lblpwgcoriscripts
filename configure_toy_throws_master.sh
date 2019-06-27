#!/bin/bash

declare -A OPTS

OPTS[QOS]="standard"
OPTS[TIME_REQ_H]=24
OPTS[NNODES]=1
OPTS[SYSTLIST]="allsyst"
OPTS[SAMPLELIST]="ndfd"
OPTS[PENALTY]="th13"
OPTS[HIERARCHY]="1"
OPTS[UNITSAFETIME_M]=75
OPTS[TASKSPERNODE]=64
OPTS[OSCVARS]="alloscvars"

OUTPUTNAME="throws_master.sh"

while [[ ${#} -gt 0 ]]; do
  key="$1"
  case $key in

      -T|--time-req-h)
        if [[ ${#} -lt 2 ]]; then echo "[ERROR]: ${1} expected a value."; exit 1; fi
        OPTS[TIME_REQ_H]="$2"
        echo "[OPT]: Requesting ${OPTS[QOS]} hours."; shift # past argument
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
      echo -e "\t-S|--systlist       : Systematic list specifier: default =\"allsyst\""
      echo -e "\t-e|--samplelist     : Sample and exposure specifier: default = \"ndfd\""
      echo -e "\t-p|--penalty        : Oscillation penalty specifier: default = \"th13\""
      echo -e "\t-h|--hierarchy      : Hierarchy specifier: default = \"1\""
      echo -e "\t-O|--oscvars        : Osc var string: default = \"alloscvars\"."
      echo -e "\t-U|--safe-unit-m    : Estimated long fit time in minutes: default = \"75\""
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

cat toy_throws_master.sh.in > configuring.toy_throws_master.sh.in
for i in QOS TIME_REQ_H NNODES TASKSPERNODE SYSTLIST SAMPLELIST PENALTY HIERARCHY OSCVARS UNITSAFETIME_M; do
  echo "OPT[${i}] = ${OPTS[${i}]}"
  sed -i "s/__${i}__/${OPTS[${i}]}/g" configuring.toy_throws_master.sh.in
done

mv configuring.toy_throws_master.sh.in ${OUTPUTNAME}
