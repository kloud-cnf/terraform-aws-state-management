# terraform-aws-remote-backend

![](https://img.shields.io/badge/Terraform-1.5x-623CE4?logo=terraform)

> Terraform module to provision account(s) with S3 State Bucket + DynamoDB lock table to manage terraform remote state

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Contents

- [Description](#description)
  - [Key Features](#key-features)
- [Avoid Locking Yourself Out 🔐](#avoid-locking-yourself-out-)
- [The Chicken and the Egg 🥚](#the-chicken-and-the-egg-)
  - [Local State Deployment](#local-state-deployment)
  - [Transitioning to Remote State](#transitioning-to-remote-state)
    - [Example backend configuration](#example-backend-configuration)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

## Description

This Terraform module enables the creation and configuration of an S3 bucket for storing Terraform state files, along with a DynamoDB table for state locking. 

It utilizes CloudFormation to enable bootstrapping new AWS account(s) within an AWS Organizational structure. The module enforces resource-based IAM policies to restrict access to the created resources.

---

### Key Features

1. **Simplified Setup**: Streamlines the creation of infrastructure components for Terraform state management, including S3 bucket and DynamoDB table.
2. **CloudFormation Integration**: Leveraging AWS CloudFormation for native bootstrapping of AWS accounts promoting consistency and infrastructure-as-code practices.
3. **Scalable State Management**: Store Terraform state files in an S3 bucket to manage state across regions.
4. **State Locking**: DynamoDB table provides a locking mechanism to prevent concurrent modifications, ensuring Terraform state integrity and consistency.
5. **Fine-Grained Access Control**: Define resource-based IAM policies for precise control over access to the S3 state bucket, maintaining security and compliance.

---

## Avoid Locking Yourself Out 🔐

When configuring your state buckets for Terraform, it's crucial to avoid accidentally locking yourself out of the bucket. Pay close attention to the values provided in `var.state_bucket_allowed_roles` and `var.state_bucket_allowed_users` as they dictate access to the S3 bucket through its access policy.

If you do lock yourself out, [login as root to remove the buckets access policy to regain access](https://repost.aws/knowledge-center/s3-accidentally-denied-access).

---

## The Chicken and the Egg 🥚

For the initial deployment, you must use [local state](#local-state-deployment) and have Terraform installed on your machine. This allows you to create the necessary infrastructure within your AWS account without relying on external storage. Once initial deployment is complete, you can [transition to remote state config](#transitioning-to-remote-state).

---

### Local State Deployment

To begin using this module, the initial deployment must be done using local state. This requires Terraform to be installed and configured on your local machine. By leveraging local state, you can create the necessary infrastructure resources within your AWS account(s) without relying on external state storage.

During local state deployment, the module provisions the S3 bucket and DynamoDB table for state management. These resources will be used for subsequent Terraform operations to ensure consistency and integrity.

---

### Transitioning to Remote State

Once the S3 bucket and DynamoDB table are provisioned successfully using local state, you can transition to using remote state, follow these steps:

1. Ensure that you have the required access credentials for the chosen backend, such as AWS access key and secret key for S3.
2. Modify your Terraform configuration to include the [backend configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) for remote state storage.
3. Run terraform init to initialize the backend configuration.
4. **Migrate the existing local state to the remote state** by using the `terraform state push` command. This will upload the local state to the configured remote backend.
5. Verify that the state has been successfully migrated by running terraform state list or any other Terraform command that relies on the state.

Once the state has been successfully migrated to the remote backend, you can continue managing your infrastructure using Terraform with the added benefits of remote state management.

Remember that if any changes are made to the infrastructure outside of Terraform, such as manually modifying resources in the AWS Console, it is crucial to keep the state in sync by refreshing it with terraform state pull.

#### Example backend configuration
```
terraform {
  backend "s3" {
    bucket         = "terraform-state-<account__id>"
    dynamodb_table = "terraform-locks-<account__id>"
    encrypt        = true
    key            = "<component>/<region>/<state_file_name>.tfstate"
    region         = "eu-west-1"
  }
}
```

---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.terraform_remote_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_cloudformation_stack_set.terraform_remote_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set_instance.terraform_remote_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_organizations_organizational_units.level_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level_4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level_5](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_state_config"></a> [state\_config](#input\_state\_config) | Configuration options for deploying S3+DynamoDB across many AWS account(s) for terraform state | <pre>object({<br>    stack_name      = optional(string, "terraform-remote-backend") # name given to the cloudformation deployment<br>    enable_stack    = optional(bool, true)                         # enable stack for root account<br>    enable_stackset = optional(bool, true)                         # enable stackset for target OU's `enabled_org_units`<br><br>    state_bucket_name_suffix   = string                     # suffix for S3 bucket, bucket is appended with `-<account_id>`<br>    lock_table_name_suffix     = string                     # suffix for DynamoDB table, table is appended with `-<account_id>`<br>    state_bucket_allowed_roles = list(string)               # list of IAM role names that can access the state bucket. Cross account not supported<br>    state_bucket_allowed_users = list(string)               # list of IAM Users that can access the state bucket.<br>    enabled_org_units          = optional(list(string), []) # Optional list of Target OU's, formatted from `root/<ou.name>/<ou.name>` ...<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_child_stack_name"></a> [child\_stack\_name](#output\_child\_stack\_name) | AWS CloudFormation stackset name |
| <a name="output_deployment_targets"></a> [deployment\_targets](#output\_deployment\_targets) | A list of deployment targets refrenced by OU path |
| <a name="output_root_deployment_arn"></a> [root\_deployment\_arn](#output\_root\_deployment\_arn) | AWS CloudFormation stack ARN for root account |
| <a name="output_root_stack_name"></a> [root\_stack\_name](#output\_root\_stack\_name) | AWS CloudFormation stack name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
