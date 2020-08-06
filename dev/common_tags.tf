locals {
  common_tags = "${map(
    "ModuleName", "ci_cd_pipeline",
    "CreatedFrom", "terraform",
    "SERVICE",terraform.workspace,
    "ACCOUNT",var.ACCOUNT,
    "ENVIRONMENT",var.ENVIRONMENT
  )}"
}