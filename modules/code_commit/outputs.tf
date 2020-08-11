output "repository_arn" {
  value = aws_codecommit_repository.codecommit-repo.arn
  description = "The arn of CodeCommit repo"
}

output "repository_clone_http" {
  value = aws_codecommit_repository.codecommit-repo.clone_url_http
  description = "The html url to clone repository."
}

output "repository_clone_ssh" {
  value = aws_codecommit_repository.codecommit-repo.clone_url_ssh
  description = "The ssh url to clone repository."
}