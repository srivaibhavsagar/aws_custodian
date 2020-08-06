# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module is written with 0.12 syntax, which means it is not compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}


# ----------------------------------------------------------------------------------------------------------------------
# CREATE A S3 BUCKET FOR ARTIFACT AND TERRAFORM 
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "s3_Bucket" {
  bucket        = var.s3_bucket_name
  acl           = "private"
  force_destroy = "true"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tag

  versioning {
    enabled = true
  }
}
