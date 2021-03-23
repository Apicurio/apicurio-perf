# References
Openshift Cluster Manager:  https://qaprodauth.cloud.redhat.com/openshift/

# How to install
To install the in-memory cluster, run the `install.sh` script:

`./install.sh <cluster-name> <aws-region>`

For example:

`./install.sh srs-reg-mem us-east-1`

# What will be installed?
1. An OSD cluster will be provisioned
2. The apicurio-registry-mem application will be deployed to the OSD cluster
