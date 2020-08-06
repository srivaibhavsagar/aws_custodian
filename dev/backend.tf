terraform {
  required_version = ">= 0.12"
  backend "s3" {
     key        = "module-state/dataopsmb/ci-cd-pipeline/terraform.tfstate"
    }
}
