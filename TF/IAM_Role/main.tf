######### IAM ROLE ##############
resource "aws_iam_role" "demo_role" {
  name                = var.name
  assume_role_policy  = var.assume_role_policy
  managed_policy_arns = var.managed_policy_arns
}