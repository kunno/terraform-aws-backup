# terraform aws backup module

Terraform module to manage AWS Backup

# Documentation Resources
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_framework
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_global_settings
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_region_settings
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_notifications
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document

## Usage

The following is the minimum required params for the backup module needed to create the default backup plan, which backup RDS based resources (RDS, DocumentDB) on a daily, weekly, and monthly basis

```hcl
module "backup" {
  name                = "example-name"
  backup_service_name = "example-service-name"
  environment         = "dev"
  critical            = "critical"
  bu_prefix           = ""
  kms_key_id          = "example-kms-key-id"
}
```
An example that overrides the default backup plan as follows:

```hcl
module "backup" {
  name                = "example-name"
  backup_service_name = "example-service-name"
  environment         = "dev"
  critical            = "critical"
  bu_prefix           = ""
  kms_key_id          = "example-kms-key-id"
  backup_plan         = [{
    name                     = "daily-backup-plan"
    rule_name                = "daily-backup-plan-rule"
    schedule                 = "cron(0 9 * * ? *)"
    enable_continuous_backup = true
    completion_window        = 90
    lifecycle                = [{
      cold_store_after = 30
      delete_after     = 120
    }]
    copy_action              = [{
      destination_arn = "aws:arn:destination-vault-arn"
    }]
    backup_selection_name    = "backup-daily-selection"
    backup_resource_arn      = "aws:arn:resource-to-backup-arn"
  },
  {
    name                     = "weekly-backup-plan"
    rule_name                = "weekly-backup-plan-rule"
    schedule                 = "cron(0 9 7 * ? *)"
    enable_continuous_backup = true
    completion_window        = 90
    lifecycle                = [{
      cold_store_after = 60
      delete_after     = 180
    }]
    copy_action              = [{
      destination_arn = "aws:arn:destination-vault-arn"
    }]
    backup_selection_name    = "backup-weekly-selection"
    backup_resource_arn      = "aws:arn:resource-to-backup-arn"
  }]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.6.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.6.20 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_framework.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_framework) | resource |
| [aws_backup_global_settings.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_global_settings) | resource |
| [aws_backup_region_settings.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_region_settings) | resource |
| [aws_backup_report_plan.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_report_plan) | resource |
| [aws_backup_selection.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_lock_configuration.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration) | resource |
| [aws_backup_vault_notifications.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_notifications) | resource |
| [aws_backup_vault_policy.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_sns_topic.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_iam_role.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |


## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `` | yes |
| <a name="input_backup_service_name"></a> [backup\_service\_name](#input\_backup\_service\_name) | n/a | `string` | `` | yes |
| <a name="input_backup_service_name"></a> [backup\_service\_name](#input\_backup\_service\_name) | n/a | `string` | `` | yes |
| <a name="input_backup_service_name"></a> [backup\_service\_name](#input\_backup\_service\_name) | n/a | `string` | `` | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `` | yes |
| <a name="input_backup_service_name"></a> [backup\_service\_name](#input\_backup\_service\_name) | n/a | `string` | `` | yes |
| <a name="input_critical"></a> [critical](#input\_critical) | n/a | `string` | `` | yes |
| <a name="input_bu_prefix"></a> [bu\_prefix](#input\_bu\_prefix) | n/a | `string` | `` | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | n/a | `string` | `` | yes |
| <a name="input_enable_backup_global_settings"></a> [enable\_backup\_global\_settings](#input\_enable\_backup\_global\_settings) | n/a | `bool` | `false` | no |
| <a name="input_backup_global_settings"></a> [backup\_global\_settings](#input\_backup\_global\_settings) | n/a | `map(string)` | `{`<br>` "isCrossAccountBackupEnabled" = "true" `<br>`}` | no |
| <a name="input_enable_backup_region_settings"></a> [enable\_backup\_region\_settings](#input\_enable\_backup\_region\_settings) | n/a | `bool` | `true` | no |
| <a name="input_enable_vault_lock"></a> [enable\_vault\_lock](#input\_enable\_vault\_lock) | n/a | `bool` | `true` | no |
| <a name="input_vault_lock_date"></a> [vault\_lock\_date](#input\_vault\_lock\_date) | number of days before vault lock. null for governance mode, specify day for compliance mode | `number` | `3` | no |
| <a name="input_vault_max_retain"></a> [vault\_max\_retain](#input\_vault\_max\_retain) | n/a | `number` | `1200` | no |
| <a name="input_vault_min_retain"></a> [vault\_min\_retain](#input\_vault\_min\_retain) | n/a | `number` | `7` | no |
| <a name="input_enable_backup_vault_notifications"></a> [enable\_backup\_vault\_notifications](#input\_enable\_backup\_vault\_notifications) | n/a | `bool` | `true` | no |
| <a name="input_backup_vault_events_to_notify"></a> [backup\_vault\_events\_to\_notify](#input\_backup\_vault\_events\_to\_notify) | n/a | `list(string)` | `[`<br>` "BACKUP_JOB_STARTED",`<br>` "BACKUP_JOB_COMPLETED",`<br>` "COPY_JOB_STARTED",`<br>` "COPY_JOB_SUCCESSFUL",`<br>` "COPY_JOB_FAILED",`<br>` "RESTORE_JOB_STARTED",`<br>` "RESTORE_JOB_COMPLETED",`<br>` "RECOVERY_POINT_MODIFIED"`<br>` ]` | no |
| <a name="input_backup_plan"></a> [backup\_plan](#input\_backup\_plan) | n/a | `set(object)` | `[{`<br>`    name                  = "daily-backup-plan"`<br>`    rule_name             = "daily-backup-plan-rule"`<br>`    schedule              = "cron(0 6 * * ? *)"`<br>`    lifecycle             = [{`<br>`      delete_after = 7`<br>`    }]`<br>`    backup_selection_name = "daily-backup-selection"`<br>`    backup_condition      = [{`<br>`      string_equals = [{`<br>`        key   = "aws:ResourceTag/Component"`<br>`        value = "rds"`<br>`      }]`<br>`    }]`<br>`  },`<br>`  {`<br>`    name                  = "weekly-backup-plan"`<br>`    rule_name             = "weekly-backup-plan-rule"`<br>`    schedule              = "cron(0 6 7 * ? *)"`<br>`    lifecycle             = [{`<br>`      delete_after = 28`<br>`    }]`<br>`    backup_selection_name = "weekly-backup-selection"`<br>`    backup_condition      = [{`<br>`      string_equals = [{`<br>`        key   = "aws:ResourceTag/Component"`<br>`        value = "rds"`<br>`      }]`<br>`    }]`<br>`  },`<br>`  {`<br>`    name                  = "monthly-backup-plan"`<br>`    rule_name             = "monthly-backup-plan-rule"`<br>`    schedule              = "cron(0 6 30 * ? *)"`<br>`    lifecycle             = [{`<br>`      cold_store_after = 0`<br>`    }]`<br>`    copy_action           = [{`<br>`      destination_arn = ""`<br>`    }]`<br>`    backup_selection_name = "monthly-backup-selection"`<br>`    backup_condition      = [{`<br>`      string_equals = [{`<br>`        key   = "aws:ResourceTag/Component"`<br>`        value = "rds"`<br>`      }]`<br>`    }]`<br>`  }]` | no |
| <a name="input_enable_region_services"></a> [enable\_region\_services](#input\_enable\_region\_services) | n/a | `map(any)` | `{`<br>`      "Aurora"          = true`<br>`      "DocumentDB"      = true`<br>`      "DynamoDB"        = true`<br>`      "EBS"             = true<br      "EC2"             = true`<br>`      "EFS"             = true`<br>`      "FSx"             = true`<br>`      "Neptune"         = true`<br>`      "RDS"             = true`<br>`      "Storage Gateway" = true`<br>`      "VirtualMachine"  = true`<br>`  }` | no |
| <a name="input_enable_service_backup_management"></a> [enable\_service\_backup\_management](#input\_enable\_service\_backup\_management) | n/a | `map(any)` | `{`<br>`      "Aurora"     = true`<br>`      "DocumentDB" = true`<br>`      "DynamoDB"   = true`<br>`      "EFS"        = true`<br>`      "RDS"        = true`<br>`  }` | no |
| <a name="input_backup_policy_arn"></a> [backup\_policy\_arn](#input\_backup\_policy\_arn) | n/a | `string` | `arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup` | no |
| <a name="input_enable_backup_framework"></a> [enable\_backup\_framework](#input\_enable\_backup\_framework) | n/a | `bool` | `false` | no |
| <a name="input_framework_control"></a> [framework\_control](#input\_framework\_control) | n/a | `set(object)` | `[{`<br>`    name        = "BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK"`<br>`    input_param = [{`<br>`      name  = "requiredRetentionDays"`<br>`      value = "35"`<br>`    }]`<br>`  },`<br>`  {`<br>`    name        = "BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK"`<br>`    input_param = [{`<br>`      name  = "requiredFrequencyUnit"`<br>`      value = "hours"`<br>`    },`<br>`    {`<br>`      name  = "requiredRetentionDays"`<br>`      value = "35"`<br>`    },`<br>`    {`<br>`      name  = "requiredFrequencyValue"`<br>`      value = "1"`<br>`    }]`<br>`  },`<br>`  {`<br>`    name = "BACKUP_RECOVERY_POINT_ENCRYPTED"`<br>`  },`<br>`  {`<br>`    name  = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_PLAN"`<br>`    scope = [{`<br>`      resource_types = [`<br>`        "RDS",`<br>`        ]`<br>`    }]`<br>`  },`<br>`  {`<br>`    name = "BACKUP_RECOVERY_POINT_MANUAL_DELETION_DISABLED"`<br>`  },`<br>`  {`<br>`    name        = "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_VAULT_LOCK"`<br>`    input_param = [{`<br>`      name  = "maxRetentionDays"`<br>`      value = "100"`<br>`    },`<br>`    {`<br>`      name  = "minRetentionDays"`<br>`      value = "1"`<br>`    }]`<br>`    scope      = [{`<br>`      resource_types = [`<br>`        "RDS",`<br>`        ]`<br>`    }]`<br>`  },`<br>`  {`<br>`    name        = "BACKUP_LAST_RECOVERY_POINT_CREATED"`<br>`    input_param = [{`<br>`      name  = "recoveryPointAgeUnit"`<br>`      value = "days"`<br>`    },`<br>`    {`<br>`      name  = "recoveryPointAgeValue"`<br>`      value = "1"`<br>`    }]`<br>`    scope      = [{`<br>`      resource_types = [`<br>`        "RDS",`<br>`        ]`<br>`    }]`<br>`  }]` | no |
| <a name="input_enable_backup_report"></a> [enable\_backup\_report](#input\_enable\_backup\_report) | n/a | `bool` | `false` | no |
| <a name="input_backup_report_format"></a> [backup\_report\_format](#input\_backup\_report\_format) | n/a | `list(string)` | `[`<br>`    "CSV",`<br>`    "JSON"`<br>`  ]` | no |
| <a name="input_backup_report_s3_bucket"></a> [backup\_report\_s3\_bucket](#input\_backup\_report\_s3\_bucket) | n/a | `string` | `""` | no |
| <a name="input_backup_report_template"></a> [backup\_report\_template](#input\_backup\_report\_template) | n/a | `string` | `BACKUP_JOB_REPORT` | no |
#

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.62.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.7.0 |
| <a name="provider_aws.west"></a> [aws.west](#provider\_aws.west) | 5.7.0 |

## Notes
<a name="provider_aws.west"></a> [aws.west](#provider\_aws.west) should be
defined in root module if `var.enable_cross_region_vault` is `true`

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_framework.backup_framework](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_framework) | resource |
| [aws_backup_global_settings.backup_global_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_global_settings) | resource |
| [aws_backup_plan.backup_plan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_region_settings.backup_region_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_region_settings) | resource |
| [aws_backup_report_plan.backup_report](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_report_plan) | resource |
| [aws_backup_selection.backup_selection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.backup_cross_region_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault.backup_vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_lock_configuration.backup_cross_region_vault_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration) | resource |
| [aws_backup_vault_lock_configuration.backup_vault_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration) | resource |
| [aws_backup_vault_notifications.backup_vault_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_notifications) | resource |
| [aws_backup_vault_policy.backup_cross_region_vault_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_backup_vault_policy.backup_vault_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_iam_role.backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.backup_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.backup_report_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_sns_topic.backup_vault_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.backup_vault_sns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.backup_vault_sns_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_iam_policy_document.backup_plan_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.backup_vault_notification_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.backup_vault_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_alias.backup_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_kms_alias.backup_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_global_settings"></a> [backup\_global\_settings](#input\_backup\_global\_settings) | n/a | `map(string)` | <pre>{<br>  "isCrossAccountBackupEnabled": "true"<br>}</pre> | no |
| <a name="input_backup_plan"></a> [backup\_plan](#input\_backup\_plan) | n/a | <pre>list(object({<br>    name                     = string<br>    rule_name                = string<br>    schedule                 = optional(string)<br>    enable_continuous_backup = optional(bool)<br>    start_window             = optional(number)<br>    completion_window        = optional(number)<br>    recovery_point_tags      = optional(map(string))<br>    lifecycle                = optional(set(object({<br>      cold_store_after = optional(number)<br>      delete_after     = optional(number)<br>    })))<br>    copy_action              = optional(set(object({<br>      destination_arn = string<br>    })))<br>    backup_selection_name    = string<br>    backup_condition         = optional(set(object({<br>      string_equals     = optional(set(object({<br>        key   = string<br>        value = string<br>      })))<br>      string_like       = optional(set(object({<br>        key   = string<br>        value = string<br>      })))<br>      string_not_equals = optional(set(object({<br>        key   = string<br>        value = string<br>      })))<br>      string_not_like   = optional(set(object({<br>        key   = string<br>        value = string<br>      })))<br>    })))<br>    backup_resource_arn      = optional(list(string))<br>    not_backup_resource_arn  = optional(list(string))<br>    selection_tag            = optional(set(object({<br>      type  = string<br>      key   = string<br>      value = string<br>    })))<br>  }))</pre> | <pre>[<br>  {<br>    "backup_condition": [<br>      {<br>        "string_equals": [<br>          {<br>            "key": "aws:ResourceTag/Component",<br>            "value": "rds"<br>          }<br>        ]<br>      }<br>    ],<br>    "backup_resource_arn": [<br>      "*"<br>    ],<br>    "backup_selection_name": "daily-backup-selection",<br>    "lifecycle": [<br>      {<br>        "delete_after": 7<br>      }<br>    ],<br>    "name": "daily-backup-plan",<br>    "rule_name": "daily-backup-plan-rule",<br>    "schedule": "cron(0 6 * * ? *)"<br>  },<br>  {<br>    "backup_condition": [<br>      {<br>        "string_equals": [<br>          {<br>            "key": "aws:ResourceTag/Component",<br>            "value": "rds"<br>          }<br>        ]<br>      }<br>    ],<br>    "backup_resource_arn": [<br>      "*"<br>    ],<br>    "backup_selection_name": "weekly-backup-selection",<br>    "lifecycle": [<br>      {<br>        "delete_after": 28<br>      }<br>    ],<br>    "name": "weekly-backup-plan",<br>    "rule_name": "weekly-backup-plan-rule",<br>    "schedule": "cron(0 6 7 * ? *)"<br>  },<br>  {<br>    "backup_condition": [<br>      {<br>        "string_equals": [<br>          {<br>            "key": "aws:ResourceTag/Component",<br>            "value": "rds"<br>          }<br>        ]<br>      }<br>    ],<br>    "backup_resource_arn": [<br>      "*"<br>    ],<br>    "backup_selection_name": "monthly-backup-selection",<br>    "lifecycle": [<br>      {<br>        "cold_store_after": 0<br>      }<br>    ],<br>    "name": "monthly-backup-plan",<br>    "rule_name": "monthly-backup-plan-rule",<br>    "schedule": "cron(0 6 30 * ? *)"<br>  }<br>]</pre> | no |
| <a name="input_backup_policy_arn"></a> [backup\_policy\_arn](#input\_backup\_policy\_arn) | n/a | `string` | `"arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"` | no |
| <a name="input_backup_report_format"></a> [backup\_report\_format](#input\_backup\_report\_format) | n/a | `list(string)` | <pre>[<br>  "CSV",<br>  "JSON"<br>]</pre> | no |
| <a name="input_backup_report_s3_bucket"></a> [backup\_report\_s3\_bucket](#input\_backup\_report\_s3\_bucket) | n/a | `string` | `""` | no |
| <a name="input_backup_report_template"></a> [backup\_report\_template](#input\_backup\_report\_template) | n/a | `string` | `"BACKUP_JOB_REPORT"` | no |
| <a name="input_backup_service_name"></a> [backup\_service\_name](#input\_backup\_service\_name) | n/a | `string` | n/a | yes |
| <a name="input_backup_vault_events_to_notify"></a> [backup\_vault\_events\_to\_notify](#input\_backup\_vault\_events\_to\_notify) | n/a | `list(string)` | <pre>[<br>  "BACKUP_JOB_STARTED",<br>  "BACKUP_JOB_COMPLETED",<br>  "COPY_JOB_STARTED",<br>  "COPY_JOB_SUCCESSFUL",<br>  "COPY_JOB_FAILED",<br>  "RESTORE_JOB_STARTED",<br>  "RESTORE_JOB_COMPLETED",<br>  "RECOVERY_POINT_MODIFIED"<br>]</pre> | no |
| <a name="input_bu_prefix"></a> [bu\_prefix](#input\_bu\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_critical"></a> [critical](#input\_critical) | n/a | `string` | n/a | yes |
| <a name="input_cross_region_kms_key_id"></a> [cross\_region\_kms\_key\_id](#input\_cross\_region\_kms\_key\_id) | n/a | `string` | `""` | no |
| <a name="input_cross_region_vault_lock_date"></a> [cross\_region\_vault\_lock\_date](#input\_cross\_region\_vault\_lock\_date) | number of days before lock date. null for governance mode, specify for compliance mode | `number` | `null` | no |
| <a name="input_cross_region_vault_max_retain"></a> [cross\_region\_vault\_max\_retain](#input\_cross\_region\_vault\_max\_retain) | n/a | `number` | `null` | no |
| <a name="input_cross_region_vault_min_retain"></a> [cross\_region\_vault\_min\_retain](#input\_cross\_region\_vault\_min\_retain) | n/a | `number` | `null` | no |
| <a name="input_enable_backup_framework"></a> [enable\_backup\_framework](#input\_enable\_backup\_framework) | n/a | `bool` | `false` | no |
| <a name="input_enable_backup_global_settings"></a> [enable\_backup\_global\_settings](#input\_enable\_backup\_global\_settings) | n/a | `bool` | `false` | no |
| <a name="input_enable_backup_region_settings"></a> [enable\_backup\_region\_settings](#input\_enable\_backup\_region\_settings) | n/a | `bool` | `false` | no |
| <a name="input_enable_backup_report"></a> [enable\_backup\_report](#input\_enable\_backup\_report) | n/a | `bool` | `false` | no |
| <a name="input_enable_backup_vault_notifications"></a> [enable\_backup\_vault\_notifications](#input\_enable\_backup\_vault\_notifications) | n/a | `bool` | `true` | no |
| <a name="input_enable_backup_vault_sns_subscription"></a> [enable\_backup\_vault\_sns\_subscription](#input\_enable\_backup\_vault\_sns\_subscription) | n/a | `bool` | `false` | no |
| <a name="input_enable_cross_region_vault"></a> [enable\_cross\_region\_vault](#input\_enable\_cross\_region\_vault) | n/a | `bool` | `true` | no |
| <a name="input_enable_cross_region_vault_lock"></a> [enable\_cross\_region\_vault\_lock](#input\_enable\_cross\_region\_vault\_lock) | n/a | `bool` | `true` | no |
| <a name="input_enable_region_services"></a> [enable\_region\_services](#input\_enable\_region\_services) | n/a | `map(any)` | <pre>{<br>  "Aurora": true,<br>  "DocumentDB": true,<br>  "DynamoDB": true,<br>  "EBS": true,<br>  "EC2": true,<br>  "EFS": true,<br>  "Neptune": true,<br>  "RDS": true,<br>  "Storage Gateway": true,<br>  "VirtualMachine": true<br>}</pre> | no |
| <a name="input_enable_service_backup_management"></a> [enable\_service\_backup\_management](#input\_enable\_service\_backup\_management) | n/a | `map(any)` | <pre>{<br>  "Aurora": true,<br>  "DocumentDB": true,<br>  "DynamoDB": true,<br>  "EFS": true,<br>  "RDS": true<br>}</pre> | no |
| <a name="input_enable_vault_lock"></a> [enable\_vault\_lock](#input\_enable\_vault\_lock) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_framework_control"></a> [framework\_control](#input\_framework\_control) | n/a | <pre>list(object({<br>    name        = string<br>    input_param = optional(set(object({<br>      name  = string<br>      value = string<br>    })))<br>    scope       = optional(set(object({<br>      resource_types  = list(string)<br>    })))<br>  }))</pre> | <pre>[<br>  {<br>    "input_param": [<br>      {<br>        "name": "requiredRetentionDays",<br>        "value": "35"<br>      }<br>    ],<br>    "name": "BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK"<br>  },<br>  {<br>    "input_param": [<br>      {<br>        "name": "requiredFrequencyUnit",<br>        "value": "hours"<br>      },<br>      {<br>        "name": "requiredRetentionDays",<br>        "value": "35"<br>      },<br>      {<br>        "name": "requiredFrequencyValue",<br>        "value": "1"<br>      }<br>    ],<br>    "name": "BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK"<br>  },<br>  {<br>    "name": "BACKUP_RECOVERY_POINT_ENCRYPTED"<br>  },<br>  {<br>    "name": "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_PLAN",<br>    "scope": [<br>      {<br>        "resource_types": [<br>          "RDS"<br>        ]<br>      }<br>    ]<br>  },<br>  {<br>    "name": "BACKUP_RECOVERY_POINT_MANUAL_DELETION_DISABLED"<br>  },<br>  {<br>    "input_param": [<br>      {<br>        "name": "maxRetentionDays",<br>        "value": "100"<br>      },<br>      {<br>        "name": "minRetentionDays",<br>        "value": "1"<br>      }<br>    ],<br>    "name": "BACKUP_RESOURCES_PROTECTED_BY_BACKUP_VAULT_LOCK",<br>    "scope": [<br>      {<br>        "resource_types": [<br>          "RDS"<br>        ]<br>      }<br>    ]<br>  },<br>  {<br>    "input_param": [<br>      {<br>        "name": "recoveryPointAgeUnit",<br>        "value": "days"<br>      },<br>      {<br>        "name": "recoveryPointAgeValue",<br>        "value": "1"<br>      }<br>    ],<br>    "name": "BACKUP_LAST_RECOVERY_POINT_CREATED",<br>    "scope": [<br>      {<br>        "resource_types": [<br>          "RDS"<br>        ]<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_sns_subscription_confirm_timeout"></a> [sns\_subscription\_confirm\_timeout](#input\_sns\_subscription\_confirm\_timeout) | n/a | `number` | `1` | no |
| <a name="input_sns_subscription_delivery_policy"></a> [sns\_subscription\_delivery\_policy](#input\_sns\_subscription\_delivery\_policy) | n/a | `string` | `""` | no |
| <a name="input_sns_subscription_endpoint"></a> [sns\_subscription\_endpoint](#input\_sns\_subscription\_endpoint) | n/a | `string` | `null` | no |
| <a name="input_sns_subscription_endpoint_auto_confirm"></a> [sns\_subscription\_endpoint\_auto\_confirm](#input\_sns\_subscription\_endpoint\_auto\_confirm) | n/a | `bool` | `false` | no |
| <a name="input_sns_subscription_filter_policy"></a> [sns\_subscription\_filter\_policy](#input\_sns\_subscription\_filter\_policy) | n/a | `string` | `""` | no |
| <a name="input_sns_subscription_filter_policy_scope"></a> [sns\_subscription\_filter\_policy\_scope](#input\_sns\_subscription\_filter\_policy\_scope) | n/a | `string` | `""` | no |
| <a name="input_sns_subscription_protocol"></a> [sns\_subscription\_protocol](#input\_sns\_subscription\_protocol) | n/a | `string` | `null` | no |
| <a name="input_sns_subscription_raw_message_delivery"></a> [sns\_subscription\_raw\_message\_delivery](#input\_sns\_subscription\_raw\_message\_delivery) | n/a | `bool` | `false` | no |
| <a name="input_sns_subscription_redrive_policy"></a> [sns\_subscription\_redrive\_policy](#input\_sns\_subscription\_redrive\_policy) | n/a | `string` | `""` | no |
| <a name="input_sns_subscription_role_arn"></a> [sns\_subscription\_role\_arn](#input\_sns\_subscription\_role\_arn) | n/a | `string` | `null` | no |
| <a name="input_vault_lock_date"></a> [vault\_lock\_date](#input\_vault\_lock\_date) | number of days before lock date. null for governance mode, specify for compliance mode | `number` | `3` | no |
| <a name="input_vault_max_retain"></a> [vault\_max\_retain](#input\_vault\_max\_retain) | n/a | `number` | `1200` | no |
| <a name="input_vault_min_retain"></a> [vault\_min\_retain](#input\_vault\_min\_retain) | n/a | `number` | `7` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_framework_arn"></a> [backup\_framework\_arn](#output\_backup\_framework\_arn) | n/a |
| <a name="output_backup_plan_arns"></a> [backup\_plan\_arns](#output\_backup\_plan\_arns) | n/a |
| <a name="output_backup_report_plan_arn"></a> [backup\_report\_plan\_arn](#output\_backup\_report\_plan\_arn) | n/a |
| <a name="output_backup_sns_arn"></a> [backup\_sns\_arn](#output\_backup\_sns\_arn) | n/a |
| <a name="output_backup_vault_arn"></a> [backup\_vault\_arn](#output\_backup\_vault\_arn) | n/a |
<!-- END_TF_DOCS -->
