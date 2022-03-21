# Bahmni Cloud Deployment Automation

## Setting up terraform

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [aws configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
```
        aws access key : *******
        aws secret key : ******
```       
### Development Setup
This is a one-time setup that needs to be run when you clone the repo.
1. Install [pre-commit](https://pre-commit.com/#install)

        pip install pre-commit 
        (or)
        brew install pre-commit
2. Initialise pre-commit hooks
        
        pre-commit install --install-hooks

Now before every commit, the hooks will be executed.
## Backend Creation
Ignore if already exists

```
        cd terraform/backend/
        terraform init
        terraform plan
        terraform apply
```
OUTPUT:
```
         bucket         = "bahmni-tf-bucket"
         dynamodb_table = "bahmni-tf-lock"
```

## Base Creation

Creates VPC, Subnets(public,private), NAT Gateway, Route table
Output from backend will be provided in provider.tf file 

```
        cd terraform/base
        terraform init
        terraform plan
        terraform apply
```
OUTPUT:
```
        VPC_id         = #####
        Subnet_public  = #####
        Subnet_private = #####
```

## Destroy resources
To destroy any resource run this in the particular directory 
```
        terraform destroy
```
