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
