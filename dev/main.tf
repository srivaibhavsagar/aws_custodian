# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module is written with 0.12 syntax, which means it is not compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
}

# ----------------------------------------------------------------------------------------------------------------------
# CICD CUSTODIAN SETUP
# ----------------------------------------------------------------------------------------------------------------------
module "user_identity" {
  source = "../modules/caller_identity"
}

################################  S3 BUCKET CREATION #####################################################

module "s3_bucket_artifact" {
  source                   = "../modules/S3"
  account                  = var.ACCOUNT
  environment              = var.ENVIRONMENT
  s3_bucket_name = "${var.ACCOUNT}-${var.ENVIRONMENT}-s3-ci-custodian-source-artifacts"
  tag = "${merge(local.common_tags,map("Name", "${var.ACCOUNT}-${var.ENVIRONMENT}-s3-ci-custodian-source-artifacts"))}"
}


##################################### CODE COMMIT #####################################
module "code-commit" {
  source = "../modules/code_commit"
  account = var.ACCOUNT
  environment = var.ENVIRONMENT
}

#####################################  CODE BUILD AND CODE PIPELINE ######################################

module "code-build" {
  source                   = "../modules/code_build"
  account                  = var.ACCOUNT
  environment              = var.ENVIRONMENT
  artifact_s3_bucket_name  = module.s3_bucket_artifact.bucket_name
  artifact_s3_bucket_arn   = module.s3_bucket_artifact.bucket_arn
  accountno                = module.user_identity.account_id
  custodian_codebuild_name     = "${var.ACCOUNT}-${var.ENVIRONMENT}-service-codebuild-Custodian"
  # existing_vpc_id = data.terraform_remote_state.terraform_vpc.outputs.vpc-id
  # existing_private_subnet_1_id = data.terraform_remote_state.terraform_vpc.outputs.private-subnet-1-id
  # existing_private_subnet_2_id =  data.terraform_remote_state.terraform_vpc.outputs.private-subnet-1-id
  # existing_private_subnet_3_id =  data.terraform_remote_state.terraform_vpc.outputs.private-subnet-1-id
  # existing_security_group_id =  data.terraform_remote_state.terraform_vpc.outputs.security-group-id
}

module "code-pipeline" {
  source                  = "../modules/code_pipeline"
  account                 = var.ACCOUNT
  environment             = var.ENVIRONMENT
  artifact_s3_bucket_name  = module.s3_bucket_artifact.bucket_name
  artifact_s3_bucket_arn   = module.s3_bucket_artifact.bucket_arn
  accountno               = module.user_identity.account_id
  custodian_codebuild_name = module.code-build.codebuild_custodian_name
  codepipeline_name       = "${var.ACCOUNT}-${var.ENVIRONMENT}-service-codepipeline-custodian"
}