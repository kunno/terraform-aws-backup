resource "aws_sns_topic" "backup_vault_sns" {
  count             = var.enable_backup_vault_notifications ? 1 : 0
  name              = format("backup-vault-sns-%s-%s-%s", var.bu_prefix, var.name, var.environment)
  kms_master_key_id = var.kms_key_id

  tags = {
    Name        = format("backup-vault-sns-%s-%s-%s", var.bu_prefix, var.name, var.environment),
    Environment = var.environment,
    Critical    = var.critical
  }
}

resource "aws_sns_topic_policy" "backup_vault_sns_policy" {
  count  = var.enable_backup_vault_notifications ? 1 : 0
  arn    = aws_sns_topic.backup_vault_sns[count.index].arn
  policy = data.aws_iam_policy_document.backup_vault_notification_policy[count.index].json
}

resource "aws_sns_topic_subscription" "backup_vault_sns_subscription" {
  count                           = var.enable_backup_vault_sns_subscription ? 1 : 0
  endpoint                        = var.sns_subscription_endpoint
  protocol                        = var.sns_subscription_protocol
  subscription_role_arn           = var.sns_subscription_protocol == "firehose" ? var.sns_subscription_role_arn : ""
  topic_arn                       = aws_sns_topic.backup_vault_sns[count.index].arn
  confirmation_timeout_in_minutes = var.sns_subscription_confirm_timeout
  delivery_policy                 = var.sns_subscription_delivery_policy
  endpoint_auto_confirms          = var.sns_subscription_endpoint_auto_confirm
  filter_policy                   = var.sns_subscription_filter_policy
  filter_policy_scope             = var.sns_subscription_filter_policy_scope
  raw_message_delivery            = var.sns_subscription_raw_message_delivery
  redrive_policy                  = var.sns_subscription_redrive_policy
}
