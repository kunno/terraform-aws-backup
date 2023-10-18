output "backup_vault_arn" {
  value = aws_backup_vault.backup_vault.arn
}

output "backup_report_plan_arn" {
  value = var.enable_backup_report ? aws_backup_report_plan.backup_report[0].arn : null
}

output "backup_plan_arns" {
  value = { for plan in var.backup_plan : plan.name => aws_backup_plan.backup_plan[plan.name].arn }
}

output "backup_framework_arn" {
  value = var.enable_backup_framework ? aws_backup_framework.backup_framework[0].arn : null
}

output "backup_sns_arn" {
  value = var.enable_backup_vault_notifications ? aws_sns_topic.backup_vault_sns[0].arn : null
}
