# terraform-vpc

Modular Terraform  to provision a multi-tier VPC in AWS. By default it will create:

* One public and One private subnets in each AZ for the chosen region
* Internet gateway for the public subnets
* One EC2 NAT gateway per AZ for the private subnets
* One routing table per private subnet associated to the corresponding EC2 NAT gateway
* One Jumphost 
* One webserver behind an ELB


## Install Terraform

To install `terraform` follow the steps from the install web page [Getting Started](https://www.terraform.io/intro/getting-started/install.html)

## Quick Start

After setting up the binaries go to the cloned terraform directory and create a `.tfvars` file with your AWS IAM API credentials inside the `tf` subdirectory. For example, `provider-credentials.tfvars` with the following content:  
```
provider = {
  access_key = "<AWS_ACCESS_KEY>"
  secret_key = "<AWS_SECRET_KEY>"
  region     = "<AWS_EC2_REGION>"
}
```
Replace `<AWS_EC2_REGION>` with the region you want to launch the VPC in.

The global VPC variables are in the `variables.tfvars` file so edit this file and adjust the values accordingly.Set the VPC CIDR in the `vpc.cidr_block` variable (defaults to 10.0.0.0/16).

Each `.tf` file in the `tf` subdirectory is Terraform playbook where our VPC resources are being created. The `variables.tf` file contains all the variables being used and their values are being populated by the settings in the `variables.tfvars`.

To begin, start by issuing the following command inside the `terraform current working` directory: 

```
$ terraform init
```
The terraform init command is used to initialize a working directory containing Terraform configuration files.This command performs several different initialization steps in order to prepare a working directory for use.
 
```
$ terraform plan -var-file variables.tfvars -var-file provider-credentials.tfvars -out vpc.tfplan
```  
This will create lots of output about the resources that are going to be created and a `vpc.tfplan` plan file containing all the changes that are going to be applied. If this goes without any errors then we can proceed to the next step, otherwise we have to go back and fix the errors terraform has printed out. To apply the planned changes then we run:

```
$ terraform apply -var-file variables.tfvars -var-file provider-credentials.tfvars vpc.tfplan
```  

This will take some time to finish but after that we will have a new VPC deployed.

Terraform also puts some state into the `terraform.tfstate` file by default. This state file is extremely important; it maps various resource metadata to actual resource IDs so that Terraform knows what it is managing. This file must be saved and distributed to anyone who might run Terraform against the very VPC infrastructure we created so storing this in GitHub repository is a good way to go in order to share a project.


## Deleting the Infrastructure

To destroy the whole VPC we run:  
```
$ terraform destroy -var-file variables.tfvars -var-file provider-credentials.tfvars -force
```
Terraform is smart enough to determine what order things should be destroyed, same as in the case of creating or updating infrastructure.
