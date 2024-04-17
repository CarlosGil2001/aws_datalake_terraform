#--------------------------------------
# S3 Module Variables
#--------------------------------------
variable "tags" {
  description = "Project tags"
  type = map(string)
}

variable "bucket_names" {
  description = "Data lake layers"
  type        = set(string)
}

variable "folder_names_buckets" {
  description = "Folder names"
  type        = list(string)
}

variable "bucket_scripts_jobs" {
  description = "Bucket of job scripts"
  type        = string
}

variable "type_encrypted" {
  description = "Encryption type at rest"
  type        = string
  default = "AES256"
}

variable "scripts_jobs_path" {
  description = "Script jobs location"
  type        = map(string)
  default     = {"job_silverzone" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/jobs/job_silverzone.py"
                "job_goldzone" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/jobs/job_goldzone.py"}
}

variable "folder_scripts_jobs" {
  description = "Jobs scripts folder"
  type        = string
}

variable "bucket_scripts_lambda" {
  description = "Bucket of lambda scripts"
  type        = string
}

variable "scripts_lambda_path" {
  description = "Script lambda location"
  type        = map(string)
}

variable "folder_scripts_lambda" {
  description = "Lambda scripts folder"
  type        = string
}

variable "bucket_athena" {
  description = "Bucket Athena"
  type = string
  default = "athenaresult"
}

variable "lambda_function_arns" {
  description = "ARN lambdas."
  type = list(string)
}

variable "step_function_name" {
  description   = "Step Function Name"
  type          = string
}

variable "lambda_permission_not" {
  description   = "Lambda Notification"
  type          = string
  default       = "AllowExecutionFromS3Bucket"
}

variable "lambda_permission_not_action" {
  description   = "Lambda Notification Action"
  type          = string
  default       = "lambda:InvokeFunction"
}

variable "lambda_permission_not_principal" {
  description   = "Lambda Notification Principal"
  type          = string
  default       = "s3.amazonaws.com"
}

variable "s3_notification_lambda_event" {
  description   = "S3 Notification Event"
  type          = list(string)
  default       = ["s3:ObjectCreated:*"]
}

variable "upload_object_data_s3" {
  description = "Data Upload Object"
  type        = string
  default     = "ds_salaries.csv"
}

variable "upload_object_data_s3_location" {
  description = "Data Upload Object Location"
  type        = string
  default     = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/data"
}