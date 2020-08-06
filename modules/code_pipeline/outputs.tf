output "codepipeline_name_withnosmoketest"{
    value = element(concat(aws_codepipeline.notevents_codepipeline.*.name, [""]), 0)
}

output "codepipeline_name_withsmoketest"{
    value = element(concat(aws_codepipeline.events_codepipeline.*.name, [""]), 0)
}
