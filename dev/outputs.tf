
output "S3_BUCKET_ARTIFACT_NAME"{
    value = module.s3_bucket_artifact.bucket_name
}


output "CODEBUILD_CUSTODIAN_NAME"{
    value = module.code-build.codebuild_custodian_name
}


output "CODEPIPELINE_CUSTODIAN_NAME"{
    value = module.code-pipeline.codepipeline_custodian_name
}

