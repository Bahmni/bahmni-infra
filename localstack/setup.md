# Local stack installation
```
   pip3 install awscli
   pip3 install awscli-local
   pip3 install terraform-local
```

# Start localstack container
change directory to localstack directory
```
    export LOCALSTACK_API_KEY=*****
    docker-compose up 
```

# Creation of s3 bucket and dynamodb table
```
awslocal s3api create-bucket --bucket "bahmni-tf-bucket"

awslocal dynamodb create-table \
--table-name bahmni-tf-lock \
--attribute-definitions AttributeName=LockID,AttributeType=S \
--key-schema AttributeName=LockID,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
--region ap-south-1
```

# Creation of shared resources
change directory to terraform/shared/
change ami in terraform.tfvars to "amzn2-ami-hvm-2.0.20180810-x86_64-gp2"
comment metadata_options, root_block_device in terraform/bastion_host/ec2.tf
```
tflocal init -backend-config=../config.localstack.tfbackend
tflocal apply 
```

# Creation of dev/staging resources
change directory to terraform/environment/dev
```
tflocal init -backend-config=../../config.localstack.tfbackend
tflocal apply
```
