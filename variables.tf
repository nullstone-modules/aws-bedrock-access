terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}
variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  role_name = var.app_metadata["role_name"]
}

resource "aws_iam_policy" "bedrock" {
  name   = "${local.resource_name}-bedrock"
  policy = data.aws_iam_policy_document.bedrock.json
  tags   = local.tags
}

data "aws_iam_policy_document" "bedrock" {
  statement {
    sid       = "enable-bedrock-usage"
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
