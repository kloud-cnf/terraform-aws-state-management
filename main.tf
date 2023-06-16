resource "aws_cloudformation_stack" "terraform_remote_backend" {
  for_each = var.state_config.enable_stack ? toset(["this"]) : []

  name = var.state_config.stack_name

  template_body = templatefile("${path.module}/templates/stackset.yaml.tftpl", {
    state_bucket_name_suffix   = var.state_config.state_bucket_name_suffix
    lock_table_name_suffix     = var.state_config.lock_table_name_suffix
    state_bucket_allowed_roles = var.state_config.state_bucket_allowed_roles
    state_bucket_allowed_users = var.state_config.state_bucket_allowed_users
  })

  capabilities = ["CAPABILITY_NAMED_IAM"]
}

resource "aws_cloudformation_stack_set" "terraform_remote_backend" {
  for_each = var.state_config.enable_stackset ? toset(["this"]) : []

  name = var.state_config.stack_name

  template_body = templatefile("${path.module}/templates/stackset.yaml.tftpl", {
    state_bucket_name_suffix   = var.state_config.state_bucket_name_suffix
    lock_table_name_suffix     = var.state_config.lock_table_name_suffix
    state_bucket_allowed_roles = var.state_config.state_bucket_allowed_roles
    state_bucket_allowed_users = var.state_config.state_bucket_allowed_users
  })

  capabilities     = ["CAPABILITY_NAMED_IAM"]
  permission_model = "SERVICE_MANAGED"

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  lifecycle {
    ignore_changes = [administration_role_arn]
  }
}

resource "aws_cloudformation_stack_set_instance" "terraform_remote_backend" {
  for_each = var.state_config.enable_stackset && length(var.state_config.enabled_org_units) > 0 ? toset(["this"]) : []

  deployment_targets {
    organizational_unit_ids = [for ou in var.state_config.enabled_org_units : local.all_org_units[ou].id]
  }

  stack_set_name = aws_cloudformation_stack_set.terraform_remote_backend["this"].name
}