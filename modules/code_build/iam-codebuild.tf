#
# iam roles
#
resource "aws_iam_role" "dataops-codebuild" {
  name = "${var.account}-${var.service}-${var.environment}-iam-codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "dataops-codebuild" {
  role = aws_iam_role.dataops-codebuild.name
  name = "${var.account}-${var.service}-${var.environment}-iam-policy-codebuild"

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

