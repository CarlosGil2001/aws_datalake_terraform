output "lambda_function_arns" {
  description = "ARNs Lambdas"
  value       = {
    for idx, lambda_name in var.lambda_zip_files :
    lambda_name => aws_lambda_function.lambda_function_glue[idx].arn
  }
}