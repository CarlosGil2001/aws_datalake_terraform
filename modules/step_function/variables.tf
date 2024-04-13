variable "crawler_arns" {
  description = "ARN crawlers."
  type        = list(string)
}

variable "job_arns" {
  description = "ARN jobs."
  type = map(string)
}

variable "lambda_function_arns" {
  description = "ARN lambdas."
  type = list(string)
}