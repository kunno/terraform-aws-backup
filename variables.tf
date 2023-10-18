variable "name" {
  type = string
}

variable "backup_service_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "critical" {
  type = string
}

variable "bu_prefix" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "cross_region_kms_key_id" {
  type    = string
  default = ""
}

variable "enable_backup_global_settings" {
  type    = bool
  default = false
}

variable "backup_global_settings" {
  type    = map(string)
  default = {
    "isCrossAccountBackupEnabled" = "true"
  }
}

variable "enable_backup_region_settings" {
  type    = bool
  default = false
}

variable "enable_cross_region_vault" {
  type    = bool
  default = true
}
variable "enable_vault_lock" {
  type    = bool
  default = true
}

variable "enable_cross_region_vault_lock" {
  type    = bool
  default = true
}

variable "vault_lock_date" {
  type        = number
  description = "number of days before lock date. null for governance mode, specify for compliance mode"
  default     = 3
}

variable "cross_region_vault_lock_date" {
  type        = number
  description = "number of days before lock date. null for governance mode, specify for compliance mode"
  default     = null
}

variable "cross_region_vault_max_retain" {
  type    = number
  default = null
}

variable "cross_region_vault_min_retain" {
  type    = number
  default = null
}

variable "vault_max_retain" {
  type    = number
  default = 1200
}

variable "vault_min_retain" {
  type    = number
  default = 7
}

variable "enable_backup_vault_notifications" {
  type    = bool
  default = true
}

variable "backup_vault_events_to_notify" {
  type    = list(string)
  default = [
    "BACKUP_JOB_STARTED",
    "BACKUP_JOB_COMPLETED",
    "COPY_JOB_STARTED",
    "COPY_JOB_SUCCESSFUL",
    "COPY_JOB_FAILED",
    "RESTORE_JOB_STARTED",
    "RESTORE_JOB_COMPLETED",
    "RECOVERY_POINT_MODIFIED"
  ]
}

variable "backup_plan" {
  type = list(object({
    name                     = string
    rule_name                = string
    schedule                 = optional(string)
    enable_continuous_backup = optional(bool)
    start_window             = optional(number)
    completion_window        = optional(number)
    recovery_point_tags      = optional(map(string))
    lifecycle                = optional(set(object({
      cold_store_after = optional(number)
      delete_after     = optional(number)
    })))
    copy_action              = optional(set(object({
      destination_arn = string
    })))
    backup_selection_name    = string
    backup_condition         = optional(set(object({
      string_equals     = optional(set(object({
        key   = string
        value = string
      })))
      string_like       = optional(set(object({
        key   = string
        value = string
      })))
      string_not_equals = optional(set(object({
        key   = string
        value = string
      })))
      string_not_like   = optional(set(object({
        key   = string
        value = string
      })))
    })))
    backup_resource_arn      = optional(list(string))
    not_backup_resource_arn  = optional(list(string))
    selection_tag            = optional(set(object({
      type  = string
      key   = string
      value = string
    })))
  }))
  default = [{
    name                  = "daily-backup-plan"
    rule_name             = "daily-backup-plan-rule"
    schedule              = "cron(0 6 * * ? *)"
    lifecycle             = [{
      delete_after = 7
    }]
    backup_selection_name = "daily-backup-selection"
    backup_condition      = [{
      string_equals = [{
        key   = "aws:ResourceTag/Component"
        value = "rds"
      }]
    }]
    backup_resource_arn    = ["*"]
  },
  {
    name                  = "weekly-backup-plan"
    rule_name             = "weekly-backup-plan-rule"
    schedule              = "cron(0 6 7 * ? *)"
    lifecycle             = [{
      delete_after = 28
    }]
    backup_selection_name = "weekly-backup-selection"
    backup_condition      = [{
      string_equals = [{
        key   = "aws:ResourceTag/Component"
        value = "rds"
      }]
    }]
    backup_resource_arn    = ["*"]
  },
  {
    name                  = "monthly-backup-plan"
    rule_name             = "monthly-backup-plan-rule"
    schedule              = "cron(0 6 30 * ? *)"
    lifecycle             = [{
      cold_store_after = 0
    }]
    copy_action           = [{
      destination_arn = ""
    }]
    backup_selection_name = "monthly-backup-selection"
    backup_condition      = [{
      string_equals = [{
        key   = "aws:ResourceTag/Component"
        value = "rds"
      }]
    }]
    backup_resource_arn    = ["*"]
  }]
}

variable "enable_region_services" {
  type    = map(any)
  default = {
      "Aurora"          = true
      "DocumentDB"      = true
      "DynamoDB"        = true
      "EBS"             = true
      "EC2"             = true
      "EFS"             = true
      "FSx"             = true
      "Neptune"         = true
      "RDS"             = true
      "Storage Gateway" = true
      "VirtualMachine"  = true
  }
}

variable "enable_service_backup_management" {
  type = map(any)
  default = {
      "Aurora"     = true
      "DocumentDB" = true
      "DynamoDB"   = true
      "EFS"        = true
      "RDS"        = true
  }
}

variable "backup_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

variable "enable_backup_framework" {
  type    = bool
  default = false
}

variable "framework_control" {
  type    = list(object({
    name        = string
    input_param = optional(set(object({
      name  = string
      value = string
    })))
    scope       = optional(set(object({
      resource_types  = list(string)
    })))
  }))
  default = [{
    name        = "BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK"
    input_param = [{
      name  = "requiredRetentionDays"
      value = "35"
    }]
  },
  {
    name        = "BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK"
    input_param = [{
      name  = "requiredFrequencyUnit"
      value = "hours"
    },
    {
      name  = "requiredRetentionDays"
      value = "35"
    },
    {
      name  = "requiredFrequencyValue"
      value = "1"
    }]
  },
  {
    name = "BACKUP_RECOVERY_POINT_ENCRYPTED"
  },
  {
    name  = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_PLAN"
    scope = [{
      resource_types = [
        "RDS"
      ]
    }]
  },
  {
    name = "BACKUP_RECOVERY_POINT_MANUAL_DELETION_DISABLED"
  },
  {
    name        = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_VAULT_LOCK"
    input_param = [{
      name  = "maxRetentionDays"
      value = "100"
    },
    {
      name  = "minRetentionDays"
      value = "1"
    }]
    scope      = [{
      resource_types = [
        "RDS"
      ]
    }]
  },
  {
    name        = "BACKUP_LAST_RECOVERY_POINT_CREATED"
    input_param = [{
      name  = "recoveryPointAgeUnit"
      value = "days"
    },
    {
      name  = "recoveryPointAgeValue"
      value = "1"
    }]
    scope      = [{
      resource_types = [
        "RDS"
      ]
    }]
  }]
}

variable "enable_backup_report" {
  type    = bool
  default = false
}

variable "backup_report_format" {
  type    = list(string)
  default = [
    "CSV",
    "JSON"
  ]
}

variable "backup_report_s3_bucket" {
  type    = string
  default = ""
}

variable "backup_report_template" {
  type    = string
  default = "BACKUP_JOB_REPORT"
}

variable "enable_backup_vault_sns_subscription" {
  type    = bool
  default = false
}

variable "sns_subscription_endpoint" {
  type    = string
  default = null
}

variable "sns_subscription_protocol" {
  type    = string
  default = null
}

variable "sns_subscription_role_arn" {
  type    = string
  default = null
}

variable "sns_subscription_confirm_timeout" {
  type    = number
  default = 1
}

variable "sns_subscription_delivery_policy" {
  type    = string
  default = ""
}

variable "sns_subscription_endpoint_auto_confirm" {
  type    = bool
  default = false
}

variable "sns_subscription_filter_policy" {
  type    = string
  default = ""
}

variable "sns_subscription_filter_policy_scope" {
  type    = string
  default = ""
}

variable "sns_subscription_raw_message_delivery" {
  type    = bool
  default = false
}

variable "sns_subscription_redrive_policy" {
  type    = string
  default = ""
}
