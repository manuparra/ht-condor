#!/bin/bash
cd /etc/yum.repos.d
curl -O http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo
curl -O http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor
rpm --import RPM-GPG-KEY-HTCondor
yum  -y install condor-all-8.6.12
/sbin/service condor start
chkconfig condor on
## End of file