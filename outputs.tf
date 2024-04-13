output "crawlers" {
  value = module.glue.crawler_arns
}

output "jobs" {
  value = module.glue.job_arns
}

output "lambda" {
  value = module.lambda.lambda_function_arns
}