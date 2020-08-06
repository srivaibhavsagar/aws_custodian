# Define the provider
provider "aws" {
  region  = var.AWS_REGION # The region in which you want to Operate
  profile = var.PROFILE_NAME
}
