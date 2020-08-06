data "terraform_remote_state" "terraform_vpc" {
  backend = "s3"
  config = {
    bucket     = "${var.ACCOUNT}-${var.ENVIRONMENT}-s3-backend" 
    key        = "module-state/dataopsmb/vpc/terraform.tfstate"
    region = var.AWS_REGION
    profile =  var.PROFILE_NAME
  }
}

