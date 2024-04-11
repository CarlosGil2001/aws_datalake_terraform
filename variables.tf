#---------------------------------------
#    Tags del Proyecto
#---------------------------------------
variable "tags" {
  description = "Tags del proyecto"
  type = map(string)
}

#---------------------------------------
#    Amazon S3 Bucket
#---------------------------------------

variable "bucket_names" {
  description = "Nombres de los buckets de S3"
  type        = set(string)
}

variable "folder_names_buckets" {
  description = "Nombres de los folders en los buckets"
  type        = list(string)
}

variable "bucket_scripts_jobs" {
   description = "Buckets de los scripts jobs"
   type        = string
}

variable "scripts_jobs_path" {
   description = "Path de los scripts job"
   type        = map(string)
}

variable "folder_scripts_jobs" {
   description = "Job script folders"
   type        = string
}

variable "bucket_scripts_lambda" {
   description = "Buckets de los scripts lambda"
   type        = string
}

variable "scripts_lambda_path" {
   description = "Path de los scripts lambda"
   type        = map(string)
}

variable "folder_scripts_lambda" {
   description = "Folders de los scripts lambda"
   type        = string
}

#---------------------------------------------------
# AWS Glue catalog database
#---------------------------------------------------

variable "catalog_database_name" {
  description = "Nombre de Database Catalog"
  type        = string
}

#---------------------------------------------------
# AWS Glue crawler
#---------------------------------------------------
variable "crawler_names" {
  description = "Nombre de Crawler"
  type = list(string)
}

#---------------------------------------------------
# AWS Glue job
#---------------------------------------------------
variable "job_names" {
  description = "Nombre de los Jobs"
  type = set(string)
}


#---------------------------------------------------
# Amazon CloudWatch
#---------------------------------------------------
variable "cloudwatch_log_group_name" {
  description = "Log group"
  type = string
}