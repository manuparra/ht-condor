#!/bin/bash

#Temporary SELinux to 0 (permissive)
ssh condortest-1 -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-2 -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-3 -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-4 -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-5 -o StrictHostKeyChecking=no "setenforce 0"

## For CM  MASTER, COLLECTOR, NEGOTIATOR
ssh condortest-1 -o StrictHostKeyChecking=no 'printf "COLLECTOR_NAME = Collector N1\nSCHEDD_HOST=condortest-2.cern.ch,condortest-3.cern.ch\nDAEMON_LIST= MASTER, SCHEDD,COLLECTOR, NEGOTIATOR\n\nALLOW_NEGOTIATOR=condortest-1.cern.ch\nALLOW_NEGOTIATOR_SCHEDD=condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-1 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-1 -o StrictHostKeyChecking=no '/sbin/service condor start'
ssh condortest-1 -o StrictHostKeyChecking=no 'systemctl stop firewalld'


## For SUBMITTER 2 MASTER, SCHEDD
ssh condortest-2 -o StrictHostKeyChecking=no 'printf "SCHEDD_NAME=Sched N2\nCOLLECTOR_HOST=condortest-1.cern.ch\nNEGOTIATOR_HOST=condortest-1.cern.ch\nALLOW_NEGOTIATOR_SCHEDD=condortest-1.cern.ch\nDAEMON_LIST= MASTER, SCHEDD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-2 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-2 -o StrictHostKeyChecking=no '/sbin/service condor start'
ssh condortest-3 -o StrictHostKeyChecking=no 'printf "SCHEDD_NAME=Sched N3\nCOLLECTOR_HOST=condortest-1.cern.ch\nNEGOTIATOR_HOST=condortest-1.cern.ch\nALLOW_NEGOTIATOR_SCHEDD=condortest-1.cern.ch\nDAEMON_LIST= MASTER, SCHEDD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-3 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-3 -o StrictHostKeyChecking=no '/sbin/service condor start'


ssh condortest-2 -o StrictHostKeyChecking=no 'systemctl stop firewalld'
ssh condortest-3 -o StrictHostKeyChecking=no 'systemctl stop firewalld'

## For WORKERS 2  MASTER, STARTD
ssh condortest-4 -o StrictHostKeyChecking=no 'printf "COLLECTOR_HOST=condortest-1.cern.ch\nNEGOTIATOR_HOST=condortest-1.cern.ch\nSCHEDD_HOST=condortest-1.cern.ch,condortest-2.cern.ch,condortest-3.cern.ch\nDAEMON_LIST= MASTER, STARTD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-4 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-4 -o StrictHostKeyChecking=no '/sbin/service condor start'
ssh condortest-5 -o StrictHostKeyChecking=no 'printf "COLLECTOR_HOST=condortest-1.cern.ch\nNEGOTIATOR_HOST=condortest-1.cern.ch\nSCHEDD_HOST=condortest-1.cern.ch,condortest-2.cern.ch,condortest-3.cern.ch\nDAEMON_LIST= MASTER, STARTD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-5 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-5 -o StrictHostKeyChecking=no '/sbin/service condor start'
ssh condortest-4 -o StrictHostKeyChecking=no 'systemctl stop firewalld'
ssh condortest-5 -o StrictHostKeyChecking=no 'systemctl stop firewalld'