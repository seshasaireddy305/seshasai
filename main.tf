resource "aws_iam_openid_connect_provider" "default" {
  url = "https://accounts.google.com"

  client_id_list = [
    "266362248691-342342xasdasdasda-apps.googleusercontent.com",
  ]

  thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]

}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.default.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:org1/*:*",
        "repo:org2/*:*"
      ]
    }
  }

}
resource "aws_iam_role" "github_actions1" {
  name               = "github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json 
}

data "aws_iam_policy_document" "github_actions1" {
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/permit-github-action"

      values = ["true"]
    }
  }
}

resource "aws_iam_policy" "github_actions1" {
  name        = "github-actions"
  description = "Grant Github Actions the ability to push to ECR"
  policy      = data.aws_iam_policy_document.github_actions1.json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions1.name
  policy_arn = aws_iam_policy.github_actions1.arn
}