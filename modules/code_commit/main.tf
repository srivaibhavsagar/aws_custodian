# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module is written with 0.12 syntax, which means it is not compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A CODE COMMIT REPOSITORY TO STORE CODE WHICH WOULD ACT AS CI/CD SOURCE.
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_codecommit_repository" "codecommit-repo" {
  repository_name = "codeCommitRepo-${var.account}-${var.environment}"
  description = "This is the new codecommit repository for Metric-Billing"
}
