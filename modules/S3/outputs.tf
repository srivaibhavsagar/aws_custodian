output "bucket_name" {
  value       = aws_s3_bucket.s3_Bucket.id
  description = "The name of new S3 bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.s3_Bucket.arn
  description = "The arn of new S3 bucket."
}
