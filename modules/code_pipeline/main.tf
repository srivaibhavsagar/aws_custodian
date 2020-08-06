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


resource "aws_codepipeline" "events_codepipeline" {
  count = (var.service == "events")?1:0
  name     = var.codepipeline_name
  role_arn = aws_iam_role.dataops-codepipeline.arn

  artifact_store {
    location = var.artifact_s3_bucket_name
    type     = "S3"

  }

  stage {
    name = "Init"

    action {
      name             = "Artifact"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        S3Bucket    = var.artifact_s3_bucket_name
        S3ObjectKey = "${var.account}-${var.service}-service/${var.environment}-version.zip" 
      }
    }
  }


  stage {
    name = "FetchSource"

    action {
      name             = "FetchSource"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["OutputArtifact"]
      version          = "1"

      configuration = {
        ProjectName = var.fetch_codebuild_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["OutputArtifact"]
      output_artifacts = ["DeployOutput"]
      version          = "1"

      configuration = {
        ProjectName = var.deploy_codebuild_name
      }
    }
  }

  stage {
   
    name = "SmokeTests"

    action {
      name             = "SmokeTests"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["DeployOutput"]
      output_artifacts = ["SmokeOutput"]
      version          = "1"

      configuration = {
        ProjectName = var.smoke_codebuild_name
      }
    }
  }


}

# ----------------------------------------------------------------------------------------------------------------------
# Create pipeline for other than dataops-mb-events
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_codepipeline" "notevents_codepipeline" {
  count = (var.service == "events")?0:1
  name     = var.codepipeline_name
  role_arn = aws_iam_role.dataops-codepipeline.arn

  artifact_store {
    location = var.artifact_s3_bucket_name
    type     = "S3"

  }

  stage {
    name = "Init"

    action {
      name             = "Artifact"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        S3Bucket    = var.deploy_s3_bucket_name
        S3ObjectKey = "${var.account}-${var.service}-service/dev-version.zip"
      }
    }
  }


  stage {
    name = "FetchSource"

    action {
      name             = "FetchSource"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["OutputArtifact"]
      version          = "1"

      configuration = {
        ProjectName = var.fetch_codebuild_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["OutputArtifact"]
      output_artifacts = ["DeployOutput"]
      version          = "1"

      configuration = {
        ProjectName = var.deploy_codebuild_name
      }
    }
  }
}
