resource "aws_iam_openid_connect_provider" "example" {
  url                   = "https://token.actions.githubusercontent.com"
  client_id_list        = ["sts.amazonaws.com"] # Audience
  thumbprint_list       = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # Obtain from OIDC provider's SSL certificate
}

resource "aws_iam_role" "example" {
  name = "oidc-role"

  assume_role_policy = jsonencode({
   


    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::529088270180:oidc-provider/token.actions.githubusercontent.com" # Change OIDC ARN
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:seshasaireddy305/seshasai:*" # Change repo anme
                },
                "ForAllValues:StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                    "token.actions.githubusercontent.com:iss": "https://token.actions.githubusercontent.com"
                }



    









        }
      }
    ]
  })
}

resource "aws_iam_policy" "example" {
  name        = "oidc-policy"
  description = "A test policy for OIDC"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:aws:s3:::example-bucket"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.example.arn
}
