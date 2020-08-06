# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module is written with 0.12 syntax, which means it is not compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}
# ----------------------------------------------------------------------------------------------------------------------
# Code Build Project for Fetch Source
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_codebuild_project" "fetch_codeBuildProject" {
  name           = var.fetch_codebuild_name
  description    = "Code Build Project for ${var.account}"
  build_timeout  = "50"
  service_role   = aws_iam_role.dataops-codebuild.arn
  source_version = "master"

  source {
    type      = "CODEPIPELINE"
    buildspec = "build/codebuild/buildspec.fetch.yml"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "TERRAFORM_WORKSPACE_NAME"
      value = var.environment
    }

  }
 
  artifacts {
    type = "CODEPIPELINE"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.fetch_codebuild_name}-${var.account}-${var.environment}"
      stream_name = "codebuild"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${var.artifact_s3_bucket_name}/build-log"
    }
  }

     vpc_config {
    vpc_id =  var.existing_vpc_id

    subnets = [
      var.existing_private_subnet_1_id,
      var.existing_private_subnet_2_id,
      var.existing_private_subnet_3_id,
    ]

    security_group_ids = [
      var.existing_security_group_id,
    ]
  }


  tags = {
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Code Build Project for Code deploy
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_codebuild_project" "deploy_codeBuildProject" {
  name           = var.deploy_codebuild_name
  description    = "Code Build Project for ${var.account}"
  build_timeout  = "50"
  service_role   = aws_iam_role.dataops-codebuild.arn
  source_version = "master"

  source {
    type      = "CODEPIPELINE"
    buildspec = "build/codebuild/buildspec.deploy.yml"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "TERRAFORM_WORKSPACE_NAME"
      value = var.environment
    }
    environment_variable {
      name  = "TERRAFORM_BUCKET"
      value = var.deploy_s3_bucket_name
    }
   }

  artifacts {
    type = "CODEPIPELINE"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.deploy_codebuild_name}-${var.account}-${var.environment}"
      stream_name = "codebuild"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${var.artifact_s3_bucket_name}/build-log"
    }
  }

    vpc_config {
    vpc_id =  var.existing_vpc_id

    subnets = [
      var.existing_private_subnet_1_id,
      var.existing_private_subnet_2_id,
      var.existing_private_subnet_3_id,
    ]

    security_group_ids = [
      var.existing_security_group_id,
    ]
  }


  tags = {
    Environment = var.environment
  }
}
# ----------------------------------------------------------------------------------------------------------------------
# Code Build Project for Smoke Test
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_codebuild_project" "smoke_codeBuildProject" {
  count = (var.service == "events")?1:0
  name           = var.smoke_codebuild_name
  description    = "Code Build Project for ${var.account}"
  build_timeout  = "50"
  service_role   = aws_iam_role.dataops-codebuild.arn
  source_version = "master"

  source {
    type      = "CODEPIPELINE"
    buildspec = "build/codebuild/buildspec.smoke.yml"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "TERRAFORM_WORKSPACE_NAME"
      value = var.environment
    }

    environment_variable {
      name  = "TERRAFORM_BUCKET"
      value = var.deploy_s3_bucket_name
    }


  }

  artifacts {
    type = "CODEPIPELINE"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.smoke_codebuild_name}-${var.account}-${var.environment}"
      stream_name = "codebuild"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${var.artifact_s3_bucket_name}/build-log"
    }
  }

   vpc_config {
    vpc_id =  var.existing_vpc_id

    subnets = [
      var.existing_private_subnet_1_id,
      var.existing_private_subnet_2_id,
      var.existing_private_subnet_3_id,
    ]

    security_group_ids = [
      var.existing_security_group_id,
    ]
  }

  tags = {
    Environment = var.environment
  }
}
