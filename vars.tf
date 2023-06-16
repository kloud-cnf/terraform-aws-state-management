variable "state_config" {
  type = object({
    stack_name      = optional(string, "terraform-remote-backend") # name given to the cloudformation deployment
    enable_stack    = optional(bool, true)                         # enable stack for root account
    enable_stackset = optional(bool, true)                         # enable stackset for target OU's `enabled_org_units`

    state_bucket_name_suffix   = string                     # suffix for S3 bucket, bucket is appended with `-<account_id>`
    lock_table_name_suffix     = string                     # suffix for DynamoDB table, table is appended with `-<account_id>`
    state_bucket_allowed_roles = list(string)               # list of IAM role names that can access the state bucket. Cross account not supported
    state_bucket_allowed_users = list(string)               # list of IAM Users that can access the state bucket.
    enabled_org_units          = optional(list(string), []) # Optional list of Target OU's, formatted from `root/<ou.name>/<ou.name>` ...
  })

  description = "Configuration options for deploying S3+DynamoDB across many AWS account(s) for terraform state"
}