# terraform-aws-state-management

> Terraform module to provision account(s) with S3 State Bucket + DynamoDB lock table 

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Contents

- [Description](#description)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)
- [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---
## Description

This Terraform module enables you to create and configure an S3 bucket for storing Terraform state files, along with a DynamoDB table for state locking. The module utilizes CloudFormation, making it suitable for bootstrapping new AWS accounts within an Organizational Unit (OU). With this module, you can easily enforce resource-based IAM policies to restrict access to the created resources.

Key Features:

1. Simplified Setup: This module streamlines the creation of the necessary infrastructure components for Terraform state management, namely an S3 bucket and a DynamoDB table for state locking.
2. CloudFormation Integration: Leveraging AWS CloudFormation, the module ensures seamless and reliable provisioning of the resources, promoting consistency and infrastructure-as-code practices.
3. Scalable State Management: By using an S3 bucket to store Terraform state files, you can easily manage state across multiple environments and collaborate with team members more effectively.
4. State Locking: The DynamoDB table created by the module helps prevent concurrent modifications to the state by providing a locking mechanism. This ensures the integrity and consistency of your Terraform state.
5. Fine-Grained Access Control: The module empowers you to define resource-based IAM policies, allowing you to precisely control access to the S3 bucket and DynamoDB table. This helps maintain security and enforce compliance requirements.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->