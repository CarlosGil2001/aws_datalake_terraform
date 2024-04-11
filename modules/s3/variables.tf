
#--------------------------------------
# S3 Module Variables
#--------------------------------------
variable "tags" {
  description = "Tags del proyecto"
  type = map(string)
}

variable "bucket_names" {
  description = "Capas del datalake"
  type        = set(string)
}

variable "folder_names_buckets" {
  description = "Nombres de las carpetas dentro de los buckets"
  type        = list(string)
}

variable "bucket_scripts_jobs" {
  description = "Buckets de los scripts jobs"
  type        = string
}

variable "type_encrypted" {
  description = "Tipo de encrypted"
  type        = string
  default = "AES256"
}

variable "scripts_jobs_path" {
  description = "Script jobs location"
  type        = map(string)
}

variable "folder_scripts_jobs" {
  description = "Folders de los scripts jobs"
  type        = string
}

variable "bucket_scripts_lambda" {
  description = "Buckets de los scripts lambda"
  type        = string
}

variable "scripts_lambda_path" {
  description = "Script lambda location"
  type        = map(string)
}

variable "folder_scripts_lambda" {
  description = "Folders de los scripts lambda"
  type        = string
}
