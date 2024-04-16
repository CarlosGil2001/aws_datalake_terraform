#----------------------------------------
# Lambda Module Variables
#----------------------------------------
variable "lambda_description" {
  description = "(Opcional) Descripción de lo que hace su función Lambda."
  type = string
  default = "Data Lake Functions"
}

variable "lambda_handler" {
  description = "(Optional) Function entrypoint in your code."
  type = string
  default = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "(Optional) Identifier of the function's runtime."
  type = string
  default = "python3.8"
}

variable "lambda_memory_size" {
  description = "(Optional) Amount of memory in MB your Lambda Function can use at runtime."
  default = 128
}

variable "lambda_architectures" {
  description = "(Optional) Instruction set architecture for your Lambda function."
  type = list(string)
  default = ["x86_64"]
}

variable "scripts_lambda_path" {
  description = "Script lambda location"
  type        = map(string)
}

variable "lambda_zip_files" {
  type    = list(string)
  default = ["update_tables_glue", "run_crawlers", "run_jobs", "event_s3"]
}

variable "folder_scripts_lambda" {
  description = "Lambda script folders"
  type        = string
}

#------------------------------------
# Others Variables
#------------------------------------
variable "bucket_lambda_scripts_name" {
  description = "Lambda script buckets"
  type        = string
}

variable "bucket_lambda_scripts_arn" {
  description = "ARN bucket lambda scripts"
  type        = string
}

variable "lambda_glue_role_arn" {
  description = "Rol lambda"
  type        = string
}

variable "lambda_timeout" {
  description = "(Optional) Amount of time your Lambda Function has to run in seconds."
  default     = 240
}

