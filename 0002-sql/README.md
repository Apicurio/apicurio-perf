# References
Openshift Cluster Manager:  https://qaprodauth.cloud.redhat.com/openshift/

# Pre-requisites
* jq
* ocm
* oc
* aws cli

Note: you will need to separately configure the AWS CLI using the command `aws configure`

# How to install
To install the SQL cluster, run the `install.sh` script:

`./install.sh <cluster-name> <aws-region> <rds-username> <rds-passsword>`

For example:

`./install.sh srs-reg-mem us-east-1 pgadmin pgsecret123`

# What will be installed?
1. An OSD cluster will be provisioned
2. An RDS Postgres instance will be provisioned
3. The apicurio-registry-sql application will be deployed to the OSD cluster

# Notes
Once the app is started, check logs by doing this:

`oc get pods`
`oc logs apicurio-registry-<id>`
