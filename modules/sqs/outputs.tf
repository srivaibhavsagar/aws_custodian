output "custodian_sqs_name"{
    value = aws_sqs_queue.custodian_queue.name
}

output "custodian_sqs_url"{
    value = aws_sqs_queue.custodian_queue.id
}
