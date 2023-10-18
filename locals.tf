locals {
  normal_backup_role_name       = format("backup-%s-%s-%s", var.bu_prefix, var.name, var.environment)
  modified_backup_role_name     = format("backup-%s-%s-%s-%s", var.backup_service_name, var.bu_prefix, var.name, var.environment)
  backup_role_name              = var.backup_service_name != "" ? local.modified_backup_role_name : local.normal_backup_role_name
}
