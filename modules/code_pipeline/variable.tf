variable "account" {
  description = "Account name, example: Metric-Billing"
  type        = string
  default     = "mb"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "dev"
}

variable "service"{
  description = "service name"
  type = string
  default = "events"
}

variable "artifact_s3_bucket_name" {}
variable "artifact_s3_bucket_arn" {}
variable "accountno" {}
variable "deploy_s3_bucket_name" {}
variable "deploy_s3_bucket_arn" {}
variable "fetch_codebuild_name" {}
variable "deploy_codebuild_name" {}
variable "smoke_codebuild_name" {}
variable "codepipeline_name" {}
# variable "enable_smoke_tests" {}