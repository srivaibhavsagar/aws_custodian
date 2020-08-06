locals {
  common_tags = "${map(
    "ModuleName", "custodian",
    "CreatedFrom", "terraform",
    "SERVICE",terraform.workspace,
    "ACCOUNT",var.ACCOUNT,
    "ENVIRONMENT",var.ENVIRONMENT
  )}"
}