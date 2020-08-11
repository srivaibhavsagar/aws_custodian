# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module is written with 0.12 syntax, which means it is not compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

# ----------------------------------------------------------------------------------------------------------------------
# Create pipeline for dataops-mb-events
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_codepipeline" "custodian_codepipeline" {
  name     = var.codepipeline_name
  role_arn = aws_iam_role.dataops-codepipeline.arn

  artifact_store {
    location = var.artifact_s3_bucket_name
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = "codeCommitRepo-${var.account}-${var.environment}"
        BranchName     = "master"
      }
    }
  }


  stage {
    name = "custodian-build"

    action {
      name             = "CUSTODIAN"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["OutputArtifact"]
      version          = "1"

      configuration = {
        ProjectName = var.custodian_codebuild_name
      }
    }
  }
 }