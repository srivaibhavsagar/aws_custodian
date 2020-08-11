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

resource "aws_codebuild_project" "custodian_codeBuildProject" {
  name           = var.custodian_codebuild_name
  description    = "Code Build Project for ${var.account}"
  build_timeout  = "50"
  service_role   = aws_iam_role.dataops-codebuild.arn
  source_version = "master"

  source {
    type      = "CODEPIPELINE"
    buildspec = "build/codebuild/buildspec.custodian.yml"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "QueueURL"
      value = ""
    }
    environment_variable {
      name  = "MailSenderEmailAddress"
      value = "neetsri19@gmail.com"
    }
    environment_variable {
      name  = "CustodianMailerLambdaArn"
      value = "arn:aws:iam::563938067661:role/custodian-lambda"
    }
    environment_variable {
      name  = "RCPTEmaillAddress"
      value = "vaibhavsrivastava59@gmail.com"
    }
    environment_variable {
      name  = "CustodianLambdaArn"
      value = "arn:aws:iam::563938067661:role/custodian-lambda"
    }  
    environment_variable {
      name  = "OutPutBucketName"
      value = "custodian-policy"
    }   
    environment_variable {
      name  = "ToEmailAddress"
      value = "vaibhavsrivastava59@gmail.com"
    }            
  }
 
  artifacts {
    type = "CODEPIPELINE"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.custodian_codebuild_name}-${var.account}-${var.environment}"
      stream_name = "codebuild"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${var.artifact_s3_bucket_name}/custodian-build-log"
    }
  }

  #    vpc_config {
  #   vpc_id =  var.existing_vpc_id

  #   subnets = [
  #     var.existing_private_subnet_1_id,
  #     var.existing_private_subnet_2_id,
  #     var.existing_private_subnet_3_id,
  #   ]

  #   security_group_ids = [
  #     var.existing_security_group_id,
  #   ]
  # }


  tags = {
    Environment = var.environment
  }
}

