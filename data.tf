data "aws_kms_alias" "backup_primary" {
  name     = "alias/aws/backup"
}

data "aws_kms_alias" "backup_secondary" {
  count    = var.enable_cross_region_vault ? 1 : 0
  provider = aws.west
  name     = "alias/aws/backup"
}

data "aws_iam_policy_document" "backup_plan_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "backup_vault_policy" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      "backup:PutBackupVaultAccessPolicy",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:GetBackupVaultAccessPolicy",
      "backup:StartBackupJob",
      "backup:GetBackupVaultNotifications",
      "backup:PutBackupVaultNotifications",
    ]

    resources = [
      aws_backup_vault.backup_vault.arn
    ]
  }
}

data "aws_iam_policy_document" "backup_vault_notification_policy" {
  count     = var.enable_backup_vault_notifications ? 1 : 0
  policy_id = "default_policy_ID"

  statement {
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.backup_vault_sns[count.index].arn,
    ]

    sid = "default_statement_ID"
  }
}
