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



variable "artifact_s3_bucket_name" {}
variable "artifact_s3_bucket_arn" {}
variable "accountno" {}
variable "custodian_codebuild_name" {}
variable "codepipeline_name" {}
