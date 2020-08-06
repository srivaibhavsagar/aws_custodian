variable "account" {
  description = "Account name, example: Metric-Billing"
  type        = string
  default     = "mb"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "prod"
}
variable "s3_bucket_name" {
  description = "S3 bucket name"
}

variable "tag"{}