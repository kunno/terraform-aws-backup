resource "aws_iam_role" "backup_role" {
  name               = local.backup_role_name
  assume_role_policy = data.aws_iam_policy_document.backup_plan_assume_role.json
}

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  policy_arn = var.backup_policy_arn
  role       = aws_iam_role.backup_role.name
}
