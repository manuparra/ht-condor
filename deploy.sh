# For Cloud INIT /OpenStack
# Create a cinit.sh file with:
#!/bin/bash
cd /etc/yum.repos.d
curl -O http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo
curl -O  http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor
rpm --import RPM-GPG-KEY-HTCondor
yum  -y install condor-all-8.6.12
/sbin/service condor start
chkconfig condor on
## End of file


#Temporary SELinux to 0 (permissive)
ssh condortest-1 -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-2 -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-3 -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-4 -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-5 -o StrictHostKeyChecking=no "setenforce 0"

## For CM  MASTER, COLLECTOR, NEGOTIATOR
ssh condortest-1 -o StrictHostKeyChecking=no 'printf "COLLECTOR_NAME = condortest-1.cern.ch\nDAEMON_LIST= MASTER, COLLECTOR, NEGOTIATOR\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nFLOCK_TO = condortest-2.cern.ch, condortest-3.cern.ch\nALLOW_ADMINISTRATOR = \$(CONDOR_HOST)\nALLOW_OWNER = \$(FULL_HOSTNAME), \$(ALLOW_ADMINISTRATOR)\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-1 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-1 -o StrictHostKeyChecking=no '/sbin/service condor start'
ssh condortest-1 -o StrictHostKeyChecking=no 'systemctl stop firewalld'


## For SUBMITTER 2 MASTER, SCHEDD
ssh condortest-2 -o StrictHostKeyChecking=no 'printf "COLLECTOR_NAME = condortest-1.cern.ch\nDAEMON_LIST= MASTER, SCHEDD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nFLOCK_TO = condortest-2.cern.ch, condortest-3.cern.ch\nALLOW_ADMINISTRATOR = \$(CONDOR_HOST)\nALLOW_OWNER = \$(FULL_HOSTNAME), \$(ALLOW_ADMINISTRATOR)\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-2 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-2 -o StrictHostKeyChecking=no '/sbin/service condor start'
ssh condortest-3 -o StrictHostKeyChecking=no 'printf "COLLECTOR_NAME = condortest-1.cern.ch\nDAEMON_LIST= MASTER, SCHEDD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nFLOCK_TO = condortest-2.cern.ch, condortest-3.cern.ch\nALLOW_ADMINISTRATOR = \$(CONDOR_HOST)\nALLOW_OWNER = \$(FULL_HOSTNAME), \$(ALLOW_ADMINISTRATOR)\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-3 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-3 -o StrictHostKeyChecking=no '/sbin/service condor start'


ssh condortest-2 -o StrictHostKeyChecking=no 'systemctl stop firewalld'
ssh condortest-3 -o StrictHostKeyChecking=no 'systemctl stop firewalld'

## For WORKERS 2  MASTER, STARTD
ssh condortest-4 -o StrictHostKeyChecking=no 'printf "COLLECTOR_NAME = condortest-1.cern.ch\nDAEMON_LIST= MASTER, STARTD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nFLOCK_TO = condortest-2.cern.ch, condortest-3.cern.ch\nALLOW_ADMINISTRATOR = \$(CONDOR_HOST)\nALLOW_OWNER = \$(FULL_HOSTNAME), \$(ALLOW_ADMINISTRATOR)\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-4 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-4 -o StrictHostKeyChecking=no '/sbin/service condor start'
ssh condortest-5 -o StrictHostKeyChecking=no 'printf "COLLECTOR_NAME = condortest-1.cern.ch\nDAEMON_LIST= MASTER, STARTD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nFLOCK_TO = condortest-2.cern.ch, condortest-3.cern.ch\nALLOW_ADMINISTRATOR = \$(CONDOR_HOST)\nALLOW_OWNER = \$(FULL_HOSTNAME), \$(ALLOW_ADMINISTRATOR)\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-5 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-5 -o StrictHostKeyChecking=no '/sbin/service condor start'
ssh condortest-4 -o StrictHostKeyChecking=no 'systemctl stop firewalld'
ssh condortest-5 -o StrictHostKeyChecking=no 'systemctl stop firewalld'
