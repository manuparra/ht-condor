## HT-Condor Deployment

This is a tutorial to install HT-Condor from scratch with an example node configuration, consisting of 1 master node, 2 scheduler nodes, 2 workers nodes. Later we will explain each role of each service or node. For this installation you need 5 working nodes, in this case the installation is based on CERN CentOS7, but it will work perfectly for CentOS7 or distributions based on RHEL. We will install HT-Condor 9.6.12.


### Requirements

- We need 5 nodes (Bare-Metal or Virtual Machine).
- All nodes can be accessed with root account without a password (ssh password-less).
- Provide each node with a hostname (like CondorCERN-X where X will be [1 to 5]).
- Open port 9618 in the firewall of all nodes (HT-CONDOR default port is 9618).
- We will use SELinux in all nodes; set the status to ``permissive``.
- The Name and the Hostnames will be:
  - Master Node : condortest-1.cern.ch
  - Scheduler Node 1 : condortest-2.cern.ch
  - Scheduler Node 2 : condortest-3.cern.ch
  - Worker Node 1 : condortest-4.cern.ch
  - Worker Node 2 : condortest-5.cern.ch


### Some important concepts (please read before)

- The most important daemon is the MASTER. This is the first daemon that is executed on each node where HTCondor runs. All the other HTCondor daemons are launched by the master, **after it has read the configuration files**.

- The daemon that manages the pool is the **COLLECTOR**. As the name suggests, it collects the information from all the nodes running HTCondor and its services inside the pool. All the other daemons send their information to the collector, that can be queried to retrieve the status of the services. **There must be only one collector in each pool**.

- Another daemon is responsible for instantiating and executing jobs on the **WORKERS** nodes. It is the **START** daemon, or **startd**. Each worker node has its own startd, that creates a starter daemon for each job that runs on the machine. The starter manages the input and output and monitors the job execution.

- The daemon that collects the information on the jobs that must be executed, or in other words the daemon that receives the information on the submitted jobs, is called the **SCHEDULER** daemon, or **schedd**. More that one schedd can exist in the same pool. For example, one schedd can be used to manage dedicated resources and parallel jobs and one schedd for everything else. Schedd is the daemon that processes the submission details and manages the queue, but it does not decide where a job must run.

- The daemon that assigns free worker nodes and waiting jobs is the **NEGOTIATOR**. This daemon checks the list of requirements of the queued jobs and looks for free matching resources, retrieving the information from the collector. After a job is associated to a free node, the communications start and the job data are sent to the startd of the machine that will execute it.


### Schema of the deployment

For our installation we have used 5 nodes, with the following roles and services:

- 1 Master Node containing: Collector , Negotiator
- 2 Scheduler Nodes containing: Scheduler
- 2 Worker Nodes containing: Worker

The global schema, containing services and directives (condor_config.local), is the next:

![Esquema](/imgs/schema.png)

### Set-up

On all nodes:

```
cd /etc/yum.repos.d
curl -O http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel7.repo
curl -O  http://research.cs.wisc.edu/htcondor/yum/RPM-GPG-KEY-HTCondor
rpm --import RPM-GPG-KEY-HTCondor
yum  -y install condor-all-8.6.12
/sbin/service condor start
chkconfig condor on

```

From the master node (assuming you have password-less enabled in SSH):

Temporary SELinux to 0 (``permissive`) (Skip this step if you have changed the SELinux mode to permissive):

(Run from Master Node [condortest-1.cern.ch]):

```
ssh condortest-1.cern.ch -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-2.cern.ch -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-3.cern.ch -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-4.cern.ch -o StrictHostKeyChecking=no "setenforce 0"
ssh condortest-5.cern.ch -o StrictHostKeyChecking=no "setenforce 0"

``` 

Create the config file in Master Node (condortest-1.cern.ch) and restart the condor service (see the [condor_config.local](scripts/condortest-1/condor_config.local) file that will be created):

(Run from Master Node [condortest-1.cern.ch]):

```
ssh condortest-1.cern.ch -o StrictHostKeyChecking=no 'printf "COLLECTOR_NAME = Collector N1\nSCHEDD_HOST=condortest-2.cern.ch,condortest-3.cern.ch\nDAEMON_LIST= MASTER, SCHEDD,COLLECTOR, NEGOTIATOR\n\nALLOW_NEGOTIATOR=condortest-1.cern.ch\nALLOW_NEGOTIATOR_SCHEDD=condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'

ssh condortest-1 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-1 -o StrictHostKeyChecking=no '/sbin/service condor start'
```

Create the config file in Scheduler Nodes (condortest-2.cern.ch and condortest-2.cern.ch) and restart the condor service (See the condor_config.local for [Scheduler 1](scripts/condortest-2/condor_config.local) and [Scheduler 2](scripts/condortest-3/condor_config.local)):

(Run from Master Node [condortest-1.cern.ch]):

```
ssh condortest-2 -o StrictHostKeyChecking=no 'printf "SCHEDD_NAME=Sched N2\nCOLLECTOR_HOST=condortest-1.cern.ch\nNEGOTIATOR_HOST=condortest-1.cern.ch\nALLOW_NEGOTIATOR_SCHEDD=condortest-1.cern.ch\nDAEMON_LIST= MASTER, SCHEDD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-2 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-2 -o StrictHostKeyChecking=no '/sbin/service condor start'
```

(Run from Master Node [condortest-1.cern.ch]):

```
ssh condortest-3 -o StrictHostKeyChecking=no 'printf "SCHEDD_NAME=Sched N3\nCOLLECTOR_HOST=condortest-1.cern.ch\nNEGOTIATOR_HOST=condortest-1.cern.ch\nALLOW_NEGOTIATOR_SCHEDD=condortest-1.cern.ch\nDAEMON_LIST= MASTER, SCHEDD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-3 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-3 -o StrictHostKeyChecking=no '/sbin/service condor start'
```

Create the config file in Workers Nodes (condortest-4.cern.ch and condortest-5.cern.ch) and restart the condor service (See the condor_config.local for [Worker 1](scripts/condortest-4/condor_config.local) and [Worker 2](scripts/condortest-5/condor_config.local):

(Run from Master Node [condortest-1.cern.ch]):

```
ssh condortest-4 -o StrictHostKeyChecking=no 'printf "COLLECTOR_HOST=condortest-1.cern.ch\nNEGOTIATOR_HOST=condortest-1.cern.ch\nSCHEDD_HOST=condortest-1.cern.ch,condortest-2.cern.ch,condortest-3.cern.ch\nDAEMON_LIST= MASTER, STARTD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-4 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-4 -o StrictHostKeyChecking=no '/sbin/service condor start'
```

(Run from Master Node [condortest-1.cern.ch]):

```
ssh condortest-5 -o StrictHostKeyChecking=no 'printf "COLLECTOR_HOST=condortest-1.cern.ch\nNEGOTIATOR_HOST=condortest-1.cern.ch\nSCHEDD_HOST=condortest-1.cern.ch,condortest-2.cern.ch,condortest-3.cern.ch\nDAEMON_LIST= MASTER, STARTD\n\nALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_WRITE = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\nHOSTALLOW_READ = condortest-1.cern.ch, condortest-2.cern.ch, condortest-3.cern.ch, condortest-4.cern.ch, condortest-5.cern.ch\n" > /etc/condor/condor_config.local'
ssh condortest-5 -o StrictHostKeyChecking=no '/sbin/service condor stop'
ssh condortest-5 -o StrictHostKeyChecking=no '/sbin/service condor start'
```



