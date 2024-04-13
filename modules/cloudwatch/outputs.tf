#-----------------------------------
# Output Amazon CloudWatch 
#-----------------------------------
output "cloudwatch_log_group_name" {
  description = "Name cloudwatch group log"
  value = aws_cloudwatch_log_group.cloudwatch_log_group.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN cloudwatch group log"
  value = aws_cloudwatch_log_group.cloudwatch_log_group.arn
}
