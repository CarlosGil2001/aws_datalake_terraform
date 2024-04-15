
# resource "aws_lambda_function" "lambda_function_glue" {
#    count            = length(var.lambda_zip_files)
#    function_name    = "lambda-${var.lambda_zip_files[count.index]}"
#    role             = aws_iam_role.lambda_exec_glue.arn
#    handler          = "lambda_function.lambda_handler"
#    runtime          = "python3.8"
#    filename         = "s3://${var.bucket_lambda_scripts_name}/${var.folder_scripts_lambda}/${var.lambda_zip_files[count.index]}.zip"
#  }

#  resource "aws_lambda_function" "lambda_function_glue" {
#    function_name    = "lambda-test"
#    role             = aws_iam_role.lambda_exec_glue.arn
#    handler          = "update_table_br_glue.lambda_handler"
#    runtime          = "python3.8"
#    filename         = "s3://bk-lambdafunctions-project1-dev-useast1/scripts_lambda/uptable_br_glue.zip"
#  }

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

  tags = {
    Name = count.index
  }

  depends_on = [ var.lambda_glue_role_arn ]
    
}
