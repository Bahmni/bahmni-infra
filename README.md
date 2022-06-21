# Bahmni Cloud Deployment Automation

This is an Infra As Code (IAC) repository which contains various codes for creation of Infrastructure on AWS cloud.
Tech stack: Terraform, Kubernetes, AWS

## Implementation Guide
Please have a look at the following document for the implementation guide

[Bahmni Wiki - Provision AWS Infrastructure for Bahmni](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/3008233473/Provision+AWS+Infrastructure+for+Bahmni)

## Development Setup

### Setting up terraform and AWS

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

   `aws configure`     

This is a one-time setup that needs to be run only when the repo is cloned.
1. Install [pre-commit](https://pre-commit.com/#install)

        pip install pre-commit 
        (or)
        brew install pre-commit
2. Install pre-commit dependencies
        
      - [terrascan](https://github.com/accurics/terrascan)
      - [tfsec](https://github.com/aquasecurity/tfsec#installation)
      - [tflint](https://github.com/terraform-linters/tflint#installation)

3. Initialise pre-commit hooks
        
        pre-commit install --install-hooks

Now before every commit, the hooks will be executed.

### Directory Structure
```

├── ...
├── aws
├── ├── policies                  # aws custom policies
├── ├── roles                     # aws custom roles
├── terraform
|   |── modules                   # contains reusable resources across environemts
│       ├── vpc
│       ├── eks
│       ├── ....
│   ├── main.tf                   # File where provider and modules are initialized
│   ├── variables.tf
│   ├── nonprod.tfvars            # values for nonprod environment
│   ├── outputs.tf
│   ├── config.s3.tfbackend       # backend config values for s3 backend
└── ...
```

