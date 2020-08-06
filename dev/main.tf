# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module is written with 0.12 syntax, which means it is not compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
}

# ----------------------------------------------------------------------------------------------------------------------
# CICD Infra SETUP
# ----------------------------------------------------------------------------------------------------------------------
module "user_identity" {
  source = "../modules/caller_identity"
}

########################################## IAM USER ######################################################
module "iam_user" {
  source = "../modules/iam-user"
  name          = "ajnayak-${terraform.workspace}"
  force_destroy = true
  pgp_key = "keybase:srivaibhavsagar"
  tags = local.common_tags 
  # password_reset_required = true

  # SSH public key
  upload_iam_user_ssh_key = false
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0sUjdTEcOWYgQ7ESnHsSkvPUO2tEvZxxQHUZYh9j6BPZgfn13iYhfAP2cfZznzrV+2VMamMtfiAiWR39LKo/bMN932HOp2Qx2la14IbiZ91666FD+yZ4+vhR2IVhZMe4D+g8FmhCfw1+zZhgl8vQBgsRZIcYqpYux59FcPv0lP1EhYahoRsUt1SEU2Gj+jvgyZpe15lnWk2VzfIpIsZ++AeUqyHoJHV0RVOK4MLRssqGHye6XkA3A+dMm2Mjgi8hxoL5uuwtkIsAll0kSfL5O2G26nsxm/Fpcl+SKSO4gs01d9V83xiOwviyOxmoXzwKy4qaUGtgq1hWncDNIVG/aQ=="
}

################################  S3 BUCKET CREATION #####################################################

module "s3_bucket_artifact" {
  source                   = "../modules/S3"
  account                  = var.ACCOUNT
  environment              = var.ENVIRONMENT
  s3_bucket_name = "${var.ACCOUNT}-${terraform.workspace}-${var.ENVIRONMENT}-s3-ci-source-artifacts"
  tag = "${merge(local.common_tags,map("Name", "${var.ACCOUNT}-${terraform.workspace}-${var.ENVIRONMENT}-s3-ci-source-artifacts"))}"
}

module "s3_bucket_deploy" {
  source                   = "../modules/S3"
  account                  = var.ACCOUNT
  environment              = var.ENVIRONMENT
  s3_bucket_name    = "${var.ACCOUNT}-${terraform.workspace}-${var.ENVIRONMENT}-s3-ci-terraform"
  tag = "${merge(local.common_tags,map("Name", "${var.ACCOUNT}-${terraform.workspace}-${var.ENVIRONMENT}-s3-ci-terraform"))}"
}

#####################################  CODE BUILD AND CODE PIPELINE ######################################

module "code-build" {
  source                   = "../modules/code_build"
  account                  = var.ACCOUNT
  environment              = var.ENVIRONMENT
  service                  = terraform.workspace
  artifact_s3_bucket_name  = module.s3_bucket_artifact.bucket_name
  artifact_s3_bucket_arn   = module.s3_bucket_artifact.bucket_arn
  deploy_s3_bucket_name    = module.s3_bucket_deploy.bucket_name
  deploy_s3_bucket_arn     = module.s3_bucket_deploy.bucket_arn
  accountno                = module.user_identity.account_id
  fetch_codebuild_name     = "${var.ACCOUNT}-${terraform.workspace}-${var.ENVIRONMENT}-service-codebuild-FetchSource"
  deploy_codebuild_name    = "${var.ACCOUNT}-${terraform.workspace}-${var.ENVIRONMENT}-service-codebuild-Deploy"
  smoke_codebuild_name     = "${var.ACCOUNT}-${terraform.workspace}-${var.ENVIRONMENT}-service-codebuild-Smoke"
  # enable_smoke_tests       = var.ENABLE_SMOKE_TESTS
  # terraform_workspace_name = var.TERRAFORM_WORKSPACE_NAME
  existing_vpc_id = data.terraform_remote_state.terraform_vpc.outputs.vpc-id
  existing_private_subnet_1_id = data.terraform_remote_state.terraform_vpc.outputs.private-subnet-1-id
  existing_private_subnet_2_id =  data.terraform_remote_state.terraform_vpc.outputs.private-subnet-1-id
  existing_private_subnet_3_id =  data.terraform_remote_state.terraform_vpc.outputs.private-subnet-1-id
  existing_security_group_id =  data.terraform_remote_state.terraform_vpc.outputs.security-group-id
}

module "code-pipeline" {
  source                  = "../modules/code_pipeline"
  account                 = var.ACCOUNT
  environment             = var.ENVIRONMENT
  service                 = terraform.workspace
  artifact_s3_bucket_name  = module.s3_bucket_artifact.bucket_name
  artifact_s3_bucket_arn   = module.s3_bucket_artifact.bucket_arn
  deploy_s3_bucket_name    = module.s3_bucket_deploy.bucket_name
  deploy_s3_bucket_arn     = module.s3_bucket_deploy.bucket_arn
  accountno               = module.user_identity.account_id
  fetch_codebuild_name    = module.code-build.codebuild_fetchsource_name
  deploy_codebuild_name   = module.code-build.codebuild_deploy_name
  smoke_codebuild_name    = module.code-build.codebuild_smoke_name
  codepipeline_name       = "${var.ACCOUNT}-${terraform.workspace}-${var.ENVIRONMENT}-service-codepipeline"
  # enable_smoke_tests      = var.ENABLE_SMOKE_TESTS
}