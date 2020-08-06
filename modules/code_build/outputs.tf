output "codebuild_fetchsource_name"{
    value = aws_codebuild_project.fetch_codeBuildProject.name
}

output "codebuild_deploy_name"{
    value = aws_codebuild_project.deploy_codeBuildProject.name
}

output "codebuild_smoke_name"{
    value = element(concat(aws_codebuild_project.smoke_codeBuildProject.*.name, [""]), 0)
}


