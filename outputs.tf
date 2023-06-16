output "root_stack_name" {
  description = "AWS CloudFormation stack name"
  value       = var.state_config.enable_stack ? aws_cloudformation_stack.terraform_remote_backend["this"].name : null
}

output "child_stack_name" {
  description = "AWS CloudFormation stackset name"
  value       = var.state_config.enable_stackset ? aws_cloudformation_stack_set.terraform_remote_backend["this"].name : null
}

output "root_deployment_arn" {
  description = "AWS CloudFormation stack ARN for root account"
  value       = var.state_config.enable_stack ? aws_cloudformation_stack.terraform_remote_backend["this"].id : null
}

output "deployment_targets" {
  description = "A list of deployment targets refrenced by OU path"
  value = compact(flatten([
    [var.state_config.enable_stack ? lower(data.aws_organizations_organization.org.roots[0].name) : null],
    [
      var.state_config.enable_stackset ? [
        for ou_id in aws_cloudformation_stack_set_instance.terraform_remote_backend["this"].deployment_targets[0].organizational_unit_ids : [for k, v in local.all_org_units : k if v.id == ou_id]
      ] : []
    ]
    ]
  ))
}