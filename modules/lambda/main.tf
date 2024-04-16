#---------------------------------------------
# Lambda functions
#---------------------------------------------
resource "aws_lambda_function" "lambda_function_glue" {
  count            = length(var.lambda_zip_files)
  function_name    = "lambda-${var.lambda_zip_files[count.index]}"

  description      = var.lambda_description 
  role             = var.lambda_glue_role_arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  architectures    = var.lambda_architectures
  timeout          = var.lambda_timeout
  filename         = var.scripts_lambda_path[var.lambda_zip_files[count.index]]

  logging_config {
    log_format = "Text"
  }

  tags = {
    Name = count.index
  }

  depends_on = [ var.lambda_glue_role_arn, var.cloudwatch_log_group_name ]
    
}
