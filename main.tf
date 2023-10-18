resource "aws_backup_global_settings" "backup_global_settings" {
  count           = var.enable_backup_global_settings ? 1 : 0
  global_settings = var.backup_global_settings
}

resource "aws_backup_region_settings" "backup_region_settings" {
  count                               = var.enable_backup_region_settings ? 1 : 0
  resource_type_opt_in_preference     = var.enable_region_services
  resource_type_management_preference = var.enable_service_backup_management
}

resource "aws_backup_plan" "backup_plan" {
  for_each = { for plan in var.backup_plan : plan.name => plan }
  name     = each.value.name

  rule {
    rule_name                = each.value.rule_name
    target_vault_name        = aws_backup_vault.backup_vault.id
    schedule                 = try(each.value.schedule, null)
    enable_continuous_backup = try(each.value.enable_continuous_backup, null)
    start_window             = try(each.value.start_window, null)
    completion_window        = try(each.value.completion_window, null)
    recovery_point_tags      = try(each.value.recovery_point_tags, null) 

    dynamic "lifecycle" {
      for_each = try({ for cycle in each.value.lifecycle : cycle.delete_after => cycle }, [])
      content {
        cold_storage_after = try(lifecycle.value.cold_store_after, null)
        delete_after       = try(lifecycle.value.delete_after, null)
      }
    }

    dynamic "copy_action" {
      for_each = try({ for action in each.value.copy_action : action.destination_arn => action }, [])
      content {
        destination_vault_arn = try(copy_action.value.destination_arn, aws_backup_vault.backup_cross_region_vault[count.index].arn)
      }
    }
  }

  tags = {
    Name        = format("backup-plan-%s-%s-%s", var.bu_prefix, var.name, var.environment),
    Environment = var.environment,
    Critical    = var.critical
  }
}

resource "aws_backup_selection" "backup_selection" {
  for_each = { for plan in var.backup_plan : plan.name => plan }
  iam_role_arn  = aws_iam_role.backup_role.arn
  name          = each.value.backup_selection_name
  plan_id       = aws_backup_plan.backup_plan[each.value.name].id
  resources     = try(each.value.backup_resource_arn, null)
  not_resources = try(each.value.not_backup_resource_arn, null)

  dynamic "selection_tag" {
    for_each = try({ for tag in each.value.selection_tag : tag.type => tag }, [])
    content {
      type  = try(selection_tag.type, null)
      key   = try(selection_tag.key, null)
      value = try(selection_tag.value, null)
    }
  }

  dynamic "condition" {
    for_each = try({ for condition in each.value.backup_condition : condition.string_equals => condition }, [])
    content {
      dynamic "string_equals" {
        for_each = { for sequal in condition.value.string_equals : sequal.name => sequal }
        content {
          key   = try(string_equals.value.key, null)
          value = try(string_equals.value.value, null)
        }
      }

      dynamic "string_like" {
        for_each = { for slike in condition.value.string_like : slike.name => slike }
        content {
          key   = try(string_like.value.key, null)
          value = try(string_like.value.value, null)
        }
      }

      dynamic "string_not_equals" {
        for_each = { for snequals in condition.value.string_not_equals : snequals.name => snequals }
        content {
          key   = try(string_not_equals.value.key, null)
          value = try(string_not_equals.value.value, null)
        }
      }

      dynamic "string_not_like" {
        for_each = { for snlike in condition.value.string_not_like : snlike.name => snlike }
        content {
          key   = try(string_not_like.value.key, null)
          value = try(string_not_like.value.value, null)
        }
      }
    }
  }
}

resource "aws_backup_framework" "backup_framework" {
  count = var.enable_backup_framework ? 1 : 0
  name  = format("backup_framework_%s_%s_%s", var.bu_prefix, var.name, var.environment)

  dynamic "control" {
    for_each = { for framework in var.framework_control : framework.name => framework }
    content {
      name = control.value.name

      dynamic "input_parameter" {
        for_each = try( { for param in control.value.input_param : param.name => param }, [])
        content {
          name  = input_parameter.value.name
          value = input_parameter.value.value
        }
      }

      dynamic "scope" {
        for_each = try( { for scopes in control.value.scope : scopes.resource_types => scopes }, [])
        content {
          compliance_resource_types = scope.value.resource_types
        }
      }
    }
  }

  tags = {
    Name        = format("backup-framework-%s-%s-%s", var.bu_prefix, var.name, var.environment),
    Environment = var.environment,
    Critical    = var.critical
  }
}

resource "aws_s3_bucket" "backup_report_bucket" {
  count  = var.enable_backup_report ? 1 : 0
  bucket = format("backup-report-bucket-%s-%s-%s", var.bu_prefix, var.name, var.environment)

  tags = {
    Name        = format("backup-report-bucket-%s-%s-%s", var.bu_prefix, var.name, var.environment),
    Environment = var.environment,
    Critical    = var.critical
  }
}

resource "aws_backup_report_plan" "backup_report" {
  count       = var.enable_backup_report ? 1 : 0
  name        = format("backup_report_plan_%s_%s_%s", var.bu_prefix, var.name, var.environment)

  report_delivery_channel {
    formats        = var.backup_report_format
    s3_bucket_name = try(var.backup_report_s3_bucket, aws_s3_bucket.backup_report_bucket[count.index].id)
  }

  report_setting {
    report_template = var.backup_report_template
  }

  tags = {
    Name        = format("backup-report-plan-%s-%s-%s", var.bu_prefix, var.name, var.environment),
    Environment = var.environment,
    Critical    = var.critical
  }
}
