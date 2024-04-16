#---------------------------------------
#    Tags del Proyecto
#---------------------------------------
variable "tags" {
  description = "Project tags"
  type = map(string)
}

#---------------------------------------
#    Amazon S3 Bucket
#---------------------------------------

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

variable "folder_scripts_jobs" {
   description = "Job script folders"
   type        = string
}

variable "bucket_scripts_lambda" {
   description = "Bucket of lambda scripts"
   type        = string
}

variable "scripts_lambda_path" {
   description = "Path de los scripts lambda"
   type        = map(string)
}

variable "folder_scripts_lambda" {
   description = "Lambda scripts folder"
   type        = string
}

#---------------------------------------------------
# AWS Glue catalog database
#---------------------------------------------------

variable "catalog_database_name" {
  description = "Database Catalog Name."
  type        = string
}

#---------------------------------------------------
# AWS Glue crawler
#---------------------------------------------------
variable "crawler_names" {
  description = "Crawlers names."
  type = list(string)
}

#---------------------------------------------------
# AWS Glue job
#---------------------------------------------------
variable "job_names" {
  description = "Jobs names."
  type = set(string)
}

#---------------------------------------------------
# Amazon CloudWatch
#---------------------------------------------------
variable "cloudwatch_log_group_name" {
  description = "Log group"
  type = string
}