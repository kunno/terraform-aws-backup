resource "aws_backup_vault" "backup_vault" {
  name        = format("backup-vault-%s-%s-%s", var.bu_prefix, var.name, var.environment)
  kms_key_arn = try(var.kms_key_id, data.aws_kms_alias.backup_primary.arn)

  tags = {
    Name        = format("backup-vault-%s-%s-%s", var.bu_prefix, var.name, var.environment),
    Environment = var.environment,
    Critical    = var.critical
  }
}

resource "aws_backup_vault_policy" "backup_vault_policy" {
  backup_vault_name = aws_backup_vault.backup_vault.name
  policy            = data.aws_iam_policy_document.backup_vault_policy.json
}

resource "aws_backup_vault_lock_configuration" "backup_vault_config" {
  count               = var.enable_vault_lock ? 1 : 0
  backup_vault_name   = aws_backup_vault.backup_vault.name
  changeable_for_days = var.vault_lock_date
  max_retention_days  = var.vault_max_retain
  min_retention_days  = var.vault_min_retain
}

resource "aws_backup_vault" "backup_cross_region_vault" {
  count       = var.enable_cross_region_vault ? 1 : 0
  provider    = aws.west
  name        = format("backup-vault-%s-%s-%s", var.bu_prefix, var.name, var.environment)
  kms_key_arn = try(var.cross_region_kms_key_id, data.aws_kms_alias[count.index].backup_secondary.arn)

  tags = {
    Name        = format("backup-vault-%s-%s-%s", var.bu_prefix, var.name, var.environment),
    Environment = var.environment,
    Critical    = var.critical
  }
}

resource "aws_backup_vault_policy" "backup_cross_region_vault_policy" {
  count             = var.enable_cross_region_vault ? 1 : 0
  provider          = aws.west
  backup_vault_name = aws_backup_vault.backup_cross_region_vault[count.index].name
  policy            = data.aws_iam_policy_document.backup_vault_policy.json
}

resource "aws_backup_vault_lock_configuration" "backup_cross_region_vault_config" {
  count               = var.enable_cross_region_vault_lock ? 1 : 0
  provider            = aws.west
  backup_vault_name   = aws_backup_vault.backup_cross_region_vault[count.index].name
  changeable_for_days = var.cross_region_vault_lock_date
  max_retention_days  = var.cross_region_vault_max_retain
  min_retention_days  = var.cross_region_vault_min_retain
}

resource "aws_backup_vault_notifications" "backup_vault_notifications" {
  count               = var.enable_backup_vault_notifications ? 1 : 0
  backup_vault_name   = aws_backup_vault.backup_vault.id
  sns_topic_arn       = aws_sns_topic.backup_vault_sns[count.index].arn
  backup_vault_events = var.backup_vault_events_to_notify
}
