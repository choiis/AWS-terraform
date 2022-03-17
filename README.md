# AWS Terraform

## Infrastructure as Code

### Execution

* Open the aws-provider.tf file and enter the access_key and secret_key of your AWS account.
* Enter the ssh key name used by AWS in key_name of the instance.tf file.
* Prepare terraform with the init command

```bash
terraform init
```

* Create AWS infrastructure and instances written in code with the apply command

```bash
terraform apply
```

### end

* You can delete AWS resources created with terraform at once

```bash
terraform destroy
```