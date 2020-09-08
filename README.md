# prometheus-ami
This project is comprised of a Packer template and Ansible playbook which are used to build Amazon Machine Images (AMIs) for a Prometheus deployment.  

## Prerequisites
* [Docker](https://www.docker.com/) 2.0.0.3+
* [AWS Command Line Interface](https://aws.amazon.com/cli/) 1.16.155+

## Project hierarchy
The following filesystem structure is used in this project:
```
prometheus-ami
  ├── ansible/              - Ansible playbooks and requirements
  |      └── roles/         - Prometheus role definition
  └── packer/               - Packer variables, build and source configuration
```
## Configuration
### Variables
The following variables are required:

Variable    | Description | Examples
-------------|------------ |---------------
aws_region  | AWS region to create the AMI | eu-west-2
aws_subnet_filter_name  | A valid filter (wildcards allowed) to select subnet for the builder when creating the AMI | example-subnet-name-*
version | SEMVER version number used in the AMI name | 1.0.0

### prometheus.yml
The AMI will be built with a generic `prometheus.yml` configuration which configures Prometheus to monitor itself (similar to [this example](https://github.com/prometheus/prometheus/blob/8219b442c864d0807ae2e3b377587cba626bba22/documentation/examples/prometheus.yml)) and can be used for any basic testing as required. Specific EC2 instances and environments created from this AMI should replace this file with their own targets and requirements.

## Building AMIs
The recommended way of building AMIs when using this project is to configure a CI pipeline and run the Packer build process within a Docker container, for which there is a purpose-built 'packer' task. Further documentation can be found in the readme associated with the task.  
It is also possible to build AMIs manually if needed, and this process is described in more detail below.

### Building AMIs manually

To manually build a Prometheus AMI, use the AWS command line interface to establish a login to Elastic Container Registry (ECR). Once successfully logged in, launch a Packer build container with a mount point to this repository (replace `<local-path-to-this-repo>` with the path to the local directory containing this git repository and `<aws-account-id>` and  `<aws-region>` with the necessary AWS details):
```
$ cd <local-path-to-this-repo>
$ docker run -it -v $(pwd):/playbook <aws-account-id>.dkr.ecr.<aws-region>.amazonaws.com/ci-packer-container-packer-1.6.0-ansible-2.9.10:latest
```

Create a `variables.hcl` file containing the neecssary variables as described in the Configuration section of this document. For example:
```
aws_region = "eu-west-2"
aws_subnet_filter_name = "example-subnet-name-*"
version= "1.0.0"
```

Finally, change directory and export a suitable version number while running the `packer` command and providing the path to both the variable file and Packer template for the desired instance:
```
$ cd /playbook/packer
$ packer build -var-file ./variables.hcl .
```
