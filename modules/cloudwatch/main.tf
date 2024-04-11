#-------------------------------
# CloudWatch Log Group
#-------------------------------
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = var.cloudwatch_log_group_name
  
  retention_in_days = var.cloudwatch_retention_in_days
  name_prefix       = var.cloudwatch_name_prefix
  log_group_class   = var.cloudwatch_log_group_class

  tags = {
    Name = var.cloudwatch_log_group_name
  }
}