# ht-condor
HT-Condor Deployment


- The HTCondor package will automatically add a condor user/group, if it does not exist already. Sites wishing to control the attributes of this user/group should add the condor user/group manually before installation.
- Download and install the meta-data that describes the appropriate YUM repository. This example is for the stable series, on RHEL 7.
  ```
  cd /etc/yum.repos.d
  wget http://htcondor.org/yum/repo.d/htcondor-stable-rhel7.repo
  ```
Note that this step need be done only once; do not get the same repository more than once.
- Import signing key The RPMs are signed in the Redhat 6 and RedHat 7 repositories.
  ```
  wget http://htcondor.org/yum/RPM-GPG-KEY-HTCondor
  rpm --import RPM-GPG-KEY-HTCondor
  ```
- Install HTCondor.
  ```
  yum install condor-all
  ```
- As needed, edit the HTCondor configuration files to customize. The configuration files are in the directory /etc/condor/ . Do not use condor_configure or condor_install for configuration. The installation will be able to find configuration files without additional administrative intervention, as the configuration files are placed in /etc, and HTCondor searches this directory.
- Start HTCondor daemons:
  ```
  /sbin/service condor start
  ```
  
  
  
  
 Steps:
```
yum update;
yum install wget;
cd /etc/yum.repos.d
wget http://htcondor.org/yum/repo.d/htcondor-stable-rhel7.repo
yum update;
wget http://htcondor.org/yum/RPM-GPG-KEY-HTCondor
rpm --import RPM-GPG-KEY-HTCondor
yum install condor-all
service condor start
```
