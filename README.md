# container-factory
Building Singularity containers for HPC platforms

The **builds** folder stores a set of bash scripts for building Singularity containers.
An initial build will create a container that holds the source for a specific HPC code.
Subsequent builds target this code-specific container at one or more HPC platforms.
Targeting is a process whereby the container is first uploaded to a HPC host and then converted
to a sandbox, within which the research code is compiled against (MPI) libraries located on the host.
The sandbox is then converted to a new Singularity image file (SIF) for factory storage.

The **scripts** folder stores a library of bash scripts some of which are called from Singularity container
definition files as part of the initial create, whereas, other scripts are called during the targeting process.


The container factory itself exists as a machine instance within the UoE Eleanor Research Cloud. The instructions
for creating this factory instance can be found in [/scripts/fac/openstack/README.md](/scripts/fac/openstack/README.md).

After the cloud instance has been created, the factory is further configured according to [/scripts/fac/bootstrap.sh](/scripts/fac/bootstrap.sh).
The bootstrap script installs Sylabs SingularityCE and finishes by cloning this github repo into the factory.
