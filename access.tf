resource "aws_iam_policy" "bedrock" {
  name   = "${local.resource_name}-bedrock"
  policy = data.aws_iam_policy_document.bedrock.json
  tags   = local.tags
}

data "aws_iam_policy_document" "bedrock" {
  statement {
    sid       = "EnableBedrockUsage"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "bedrock:InvokeModel*",
      "bedrock:ListFoundationModels",
      "bedrock:GetModel"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "bedrock" {
  policy_arn = aws_iam_policy.bedrock.arn
  role       = local.role_name
}
