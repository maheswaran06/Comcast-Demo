
######### IAM ROLE ##############
resource "aws_iam_role" "demo_role" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}