locals {
  common_tags = "${map(
    "ModuleName", "custodian",
    "CreatedFrom", "terraform",
    "ACCOUNT",var.ACCOUNT,
    "ENVIRONMENT",var.ENVIRONMENT
  )}"
}