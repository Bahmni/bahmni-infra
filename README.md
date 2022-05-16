# Bahmni Cloud Deployment Automation

This is an Infra As Code (IAC) repository which contains various codes for creation of Infrastructure on AWS cloud.
Tech stack: Terraform, Kubernetes, AWS

>⚠️ Note: This README uses **bahmni-infra** as the local AWS_PROFILE for all AWS CLI Commands. Update the profile option in commands wherever if you want to use a different profile.  
## Setting up terraform and AWS

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
      

   `aws configure --profile bahmni-infra`     

### Development Setup
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

## Directory Structure
```

├── ...
├── aws
├── ├── policies                  # aws custom policies
├── ├── roles                     # aws custom roles
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

## Setup AWS Profile
The below command sets the AWS Profile that will be used by the aws cli commands and terraform. Update the value if you have run `aws configure` with a different profile.
   
`export AWS_PROFILE=bahmni-infra`


## Backend Creation
Terraform maintains a [state file](https://www.terraform.io/language/state) which keeps track of which resources are created. It is recommended to store the state files in remote backends.

For the [S3 backend coniguration](https://www.terraform.io/language/settings/backends/s3), manual creation of an S3 bucket and a DynamoDB table with LockID as the partition key is needed. This creation is an one-time setup and the same bucket and dynamodb table can be used across environments.

**STEPS TO CREATE S3 BUCKET:**

1: Create a Bucket

`aws s3api create-bucket --bucket <bucket-name> --create-bucket-configuration --region ap-south-1 LocationConstraint=ap-south-1`

2: Enable Versioning

`aws s3api put-bucket-versioning --bucket <bucket-name> --versioning-configuration Status=Enabled`

3: Check versioning status of bucket

`aws s3api get-bucket-versioning --bucket <bucket-name>`

**STEPS TO CREATE DYNAMO DB TABLE:**

```
aws dynamodb create-table \
--table-name bahmni-tf-lock \
--attribute-definitions AttributeName=LockID,AttributeType=S \
--key-schema AttributeName=LockID,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=2,WriteCapacityUnits=2 \
--region ap-south-1
```

Once the S3 bucket and the DynamoDB table is created, set the values in the `config.s3.tfbackend` file inside terraform directory. 

## Adding and updating policies in AWS
`aws/policies` folder contains all custom policies applied to the AWS account.

>⚠️ Note: you will need to replace {YourAccountNumber} with your account number in CLI and in the policy documents. Remember to not check in your account number to public github repositories

- `BahmniConsoleReadOnly.json` provies console read only access
- `BahmniInfraAdminAssumeRolePolicy.json` Allows user to assume BahmniInfraAdminRoleForIAMUsers Role
- `BahmniInfraAdmin.json` provides least priviledge access to provision Bahmni lite infra

To create a fresh policy 
```
aws iam create-policy --policy-name BahmniInfraAdmin --policy-document file://aws/policies/BahmniInfraAdmin.json
```

If you need to update an existing policy
1) Fetch the policy arn
```
aws iam list-policies --scope Local
```

2) (Conditional) List policy versions - Note if there are already 5 revisions of the policty you will need to delete the oldest version. Remember to fetch the oldest version where `"IsDefaultVersion": false`
```
aws iam list-policy-versions --policy-arn arn:aws:iam::{YourAccountNumber}:policy/BahmniInfraAdmin
```

3) (Conditional) Delete policy version
```
aws iam delete-policy-version --policy-arn arn:aws:iam::{YourAccountNumber}:policy/BahmniInfraAdmin --version-id v28
```

4) Apply policy changes to recate a new revision
```
aws iam create-policy-version --policy-arn arn:aws:iam::{YourAccountNumber}:policy/BahmniInfraAdmin --policy-document file://aws/policies/BahmniInfraAdmin.json --set-as-default
```

## Adding and updating roles in AWS
`aws/roles` folder contains all custom roles created in AWS account.

>⚠️ Note: you will need to replace {YourAccountNumber} with your account number in CLI and in the policy documents. Remember to not check in your account number to public github repositories
- `BahmniInfraAdminRoleForIAMUsers.json` Role that can be assumed and have BahmniInfraAdmin policy permissions

Create Role with trust policy (first time)
```
aws iam create-role --role-name BahmniInfraAdminRoleForIAMUsers --assume-role-policy-document file://aws/roles/BahmniInfraAdminRoleForIAMUsers.json
```

Get Role (verify)
```
aws iam get-role --role-name BahmniInfraAdminRoleForIAMUsers
```

If you need to update Role Trust policy
```
aws iam update-assume-role-policy --role-name BahmniInfraAdminRoleForIAMUsers --policy-document file://aws/roles/BahmniInfraAdminRoleForIAMUsers.json
```

Attaching permission policies e.g. BahmniInfraAdmin to IAM Role (first time)
```
aws iam attach-role-policy --policy-arn arn:aws:iam::{YourAccountNumber}:policy/BahmniInfraAdmin --role-name BahmniInfraAdminRoleForIAMUsers
```

## Creating a User Group for EKS Cluster Read Only Access
This step is a prerequisite before applying terraform resources.

`aws iam create-group --group-name bahmni_eks_read_only`

When IAM users are added to this group then they will get read access to resources in the EKS cluster. 

## Switching AWS Profile to assume role created above.
The role `BahmniInfraAdminRoleForIAMUsers` created above has the `BahmniInfraAdmin` policy attached which provides only least privileges that will allow to provision and de-provision infra. It is advised to use this role for security considerations.
>⚠️ Note: you will need to replace {YourAccountNumber} with your account number in CLI and in the policy documents. Remember to not check in your account number to public github repositories

Add the following lines to your AWS config file at `~/.aws/config`

```
[profile bahmni-infra-admin]
role_arn = arn:aws:iam::{YourAccountNumber}:role/BahmniInfraAdminRoleForIAMUsers
source_profile = bahmni-infra
```

Update the default profile setting by running 

`export AWS_PROFILE=bahmni-infra-admin`

## Creating shared (base) resources

Shared resources for environments contain the following. 
1. VPC
2. Subnets - Private(2), Public(2)
3. NAT Gateways
4. Internet Gateways
5. Route Tables

It is recommended to have atleast two sets of shared resources (Non-Production, Production). 
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
### Setting up Identity Mapping for Read Only Access
>⚠️ Note: you will need to replace {YourAccountNumber} with your account number in CLI

(Conditional Step) This step is need only if you want other IAM users added to bahmni-eks-read-only group to view the resources in you cluster.

1. Install [eksctl](https://eksctl.io/introduction/#installation)
2. Install [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
3. Authorise kubectl with EKS

   `aws eks update-kubeconfig --name bahmni-cluster-dev`
4. Apply Kubernetes ReadOnly Cluster Role

   `kubectl apply -f k8s-rbac/read-only.yaml`
5. Craete Identity Mapping

   ``` 
   eksctl create iamidentitymapping \
   --cluster bahmni-cluster-dev \
   --arn  arn:aws:iam::{YourAccountNumber}:role/BahmniEKSReadOnlyRoleForIAMUsers \
   --group read-only-access-group \
   --username assume-role-user \
   --no-duplicate-arns
   ```
## Destroy resources
To destroy the resources, the environments created should be destroyed first and then the shared resources should be destroyed.

To destroy the resources:
1. cd into the respective directory
2. terraform destroy
