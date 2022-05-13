# Bahmni Cloud Deployment Automation

This is an Infra As Code (IAC) repository which contains various codes for creation of Infrastructure on AWS cloud.
Tech stack: Terraform, Kubernetes, AWS

## Setting up terraform

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [aws configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
```
        aws access key : *******
        aws secret key : ******
```       
### Development Setup
This is a one-time setup that needs to be run only when the repo is cloned.
1. Install [pre-commit](https://pre-commit.com/#install)

        pip install pre-commit 
        (or)
        brew install pre-commit
2. Install pre-commit dependencies
        
      - [terrascan](https://github.com/accurics/terrascan)

3. Initialise pre-commit hooks
        
        pre-commit install --install-hooks

Now before every commit, the hooks will be executed.

## Directory Structure
```

├── ...
├── aws
├── ├── policies                  # aws custom policies
├── terraform
│   ├── environment               # each directory refers to a seperate environment
│       ├── dev
│           ├── main.tf           # provider, backend, module sourcing
│           ├── variable.tf       # variable definitions
│           ├── terraform.tfvars  # default values for variables
│       ├── staging
│           ├── main.tf
│           ├── variable.tf
│           ├── terraform.tfvars
│       ├── ...
|   |── modules   # contains reusable resources across environemts
│       ├── vpc
│       ├── eks
│       ├── ....
│   ├── shared    # resource creation that can be shared across environments
│       ├── main.tf
│       ├── variable.tf
│       ├── terraform.tfvars
│   ├── config.s3.tfbackend       # backend config values for s3 backend
└── ...
```
## Backend Creation
Terraform maintains a [state file](https://www.terraform.io/language/state) which keeps track of which resources are created. It is recommended to store the state files in remote backends.

For the [S3 backend coniguration](https://www.terraform.io/language/settings/backends/s3), manual creation of an S3 bucket and a DynamoDB table with LockID as the partition key is needed. This creation is an one-time setup and the same bucket and dynamodb table can be used across environments.

STEPS TO CREATE S3 BUCKET:

1: Create a Bucket

`aws s3api create-bucket --bucket <bucket-name> --create-bucket-configuration --region ap-south-1 LocationConstraint=ap-south-1`

2: Enable Versioning

`aws s3api put-bucket-versioning --bucket <bucket-name> --versioning-configuration Status=Enabled`

3: Check versioning status of versioning-demo-cli bucket

`aws s3api get-bucket-versioning --bucket <bucket-name>`



Once the S3 bucket and the DynamoDB table is created, set the values in the `config.s3.tfbackend` file inside terraform directory. 

## Adding and updating policies in AWS
`aws/policies` folder contains all custom policies applied to the AWS account. Below CLI assumes that your local aws profile is named `bahmni-india` - please change it accordingly or remove it if you have set `export AWS_PROFILE=your-profile`

To create a fresh policy 
```
aws iam create-policy --policy-name BahmniInfraAdmin --policy-document file://aws/policies/infra_admin.json --profile bahmni-india
```

If you need to update an existing policy
1) Fetch the policy arn
```
aws iam list-policies --scope Local --profile bahmni-india
```

2) (Conditional) List policy versions - Note if there are already 5 revisions of the policty you will need to delete the oldest version. Remember to fetch the oldest version where `"IsDefaultVersion": false`
```
aws iam list-policy-versions --policy-arn arn:aws:iam::{YourAccountNumber}:policy/BahmniInfraAdmin --profile bahmni-india
```

3) (Conditional) Delete policy version
```
aws iam delete-policy-version --policy-arn arn:aws:iam::{YourAccountNumber}:policy/BahmniInfraAdmin --version-id v28 --profile bahmni-india
```

4) Apply policy changes to recate a new revision
```
aws iam create-policy-version --policy-arn arn:aws:iam::863324974761:policy/BahmniInfraAdmin --policy-document file://aws/policies/infra_admin.json --set-as-default --profile bahmni-india-admin
```

## Creating shared (base) resources

Shared resources for environments contain the following. 
1. VPC
2. Subnets - Private(2), Public(2)
3. NAT Gateways
4. Internet Gateways
5. Route Tables

It is recommmended to have atleast two sets of shared resources (Non-Production, Production). 
```
cd terraform/shared
terraform init -backend-config=../config.s3.tfbackend
terraform plan
terraform apply
```
## Creating an Environment
Multiple environments can be brought up by reusing the modules defined.
For example, to setup only a dev enviroment. Follow the steps below.

 Have a look at `terraform.tfvars` in `environment/dev` and update the required configurations.

 ```
cd terraform/environment/dev
terraform init  -backend-config=../../config.s3.tfbackend
terraform plan
terrafrom apply
```
## Destroy resources
To destroy the resources, the environments created should be destroyed first and then the shared resources should be destroyed.

To destroy the resources:
1. cd into the respective directory
2. terraform destroy
