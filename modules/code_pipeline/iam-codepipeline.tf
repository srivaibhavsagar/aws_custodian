resource "aws_iam_role" "dataops-codepipeline" {
  name = "${var.account}-${var.service}-${var.environment}-iam-codepipelines"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "dataops-codepipeline" {
  role   = aws_iam_role.dataops-codepipeline.name
  name = "${var.account}-${var.service}-${var.environment}-iam-policy-codepipeline"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
POLICY

}




