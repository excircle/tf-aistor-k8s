# Terraform for MinIO AiStor Example

This repository is dedicated to implementing MinIO's AiStor on Kubernetes using Github Actions.

General Overview:

- Repository like this is created for or by our customers
- Settings are tuned in Github Actions YAML, Terraform, Ansible
- `git push` triggers the workflow and delivers AiStor on Vanilla Kubernetes

The directories in this repository borrow from 3 separate modules

- [CE Curated Terraform AWS VPC Module](https://github.com/excircle/tf-aws-minio-vpc)
- [CE Curated Terraform AWS EC2 Module](https://github.com/excircle/tf-cncf-k8s-node)
- [CE Curated Ansible Kubernetes Module](https://github.com/excircle/ansible-cncf-k8s-role)

These components are triggered and managed by Github Actions

# Control Mechanism

| Controller | Description |
| - | - |
| Terraform | Used to provision appropriate infrastructure for Kubernetes & AiStor |
| Ansible | Used to provision and configure Packer Image And/Or Compute Infra |
| Github Actions | Orchestration and Automation Platform for Kubernetes & AiStor |

