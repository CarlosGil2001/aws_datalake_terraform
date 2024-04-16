#--------------------------------------
# Glue Module Variables
#--------------------------------------

#-------------------------------------------
# Tags Project
#-------------------------------------------
variable "tags" {
  description = "Tags project"
  type = map(string)
}

#-------------------------------------------
# AWS Glue Catalog
#-------------------------------------------
variable "catalog_database_name" {
  description = "Name Database Catalog"
  type        = string
}

variable "catalog_database_description" {
  description = "Description of the database."
  type        = string
  default = "Catalog database for datalake"
}

variable "catalog_database_catalog_id" {
  description = "(Optional) ID of the Glue Catalog to create the database in. If omitted, this defaults to the AWS Account ID."
  default     = null
}

variable "catalog_database_location_uri" {
  description = "(Optional) The location of the database (for example, an HDFS path)."
  default     = null
}

variable "catalog_database_parameters" {
  description = "(Optional) A list of key-value pairs that define parameters and properties of the database."
  default     = null
}

#------------------------------------
#  AWS Glue Crawler
#------------------------------------
variable "crawler_names" {
  description = "Name Crawlers"
  type = list(string)
}

variable "crawler_description" {
  description = "Description crawlers"
  type        = string
  default = "Crawlers for each layer of the datalake"
}

variable "crawler_classifiers" {
  description = "(Optional) List of custom classifiers. By default, all AWS classifiers are included in a crawl, but these custom classifiers always override the default classifiers for a given classification."
  default     = null
}

variable "crawler_configuration" {
  description = "Configuración del crawler"
  type        = any
  default     = {
    CreatePartitionIndex = false
    Version              = 1
  }
}
variable "crawler_schedule" {
  description = "(Optional) A cron expression used to specify the schedule. For more information, see Time-Based Schedules for Jobs and Crawlers. For example, to run something every day at 12:15 UTC, you would specify: cron(15 12 * * ? *)."
  default     = null
}

variable "crawler_security_configuration" {
  description = "(Optional) The name of Security Configuration to be used by the crawler"
  default     = null
}

variable "crawler_table_prefix" {
  description = "(Optional) The table prefix used for catalog tables that are created."
  default     = null
}

#-------------------------------------
#  AWS Glue ETL Job
#-------------------------------------
variable "glue_role" {
  description = "Role Glue"
  type = string
}

variable "job_names" {
  description = "The name you assign to this job. It must be unique in your account."
  type = set(string)
}

variable "job_description" {
  description = "Description of the job."
  type = string
  default = "Job that consumes data from the data lake S3"
}

variable "job_glue_version" {
  description = "(Optional) The version of glue to use, for example '1.0'."
  default     = null
}

variable "job_execution_class" {
  description = "(Optional) Indicates whether the job is run with a standard or flexible execution class. The standard execution class is ideal for time-sensitive workloads that require fast job startup and dedicated resources. Valid value: FLEX, STANDARD."
  default     = null
}

variable "job_max_capacity" {
  description = "(Optional) The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs. Required when pythonshell is set, accept either 0.0625 or 1.0."
  default     = null
}

variable "job_max_retries" {
  description = "(Optional) The maximum number of times to retry this job if it fails."
  default     = null
}

variable "job_worker_type" {
  description = " (Optional) The type of predefined worker that is allocated when a job runs."
  type = string
  default = "G.1X"
}

variable "job_number_of_workers" {
  description = "(Optional) The number of workers of a defined workerType that are allocated when a job runs."
  default = 2
}

variable "job_timeout" {
  description = "(Optional) The job timeout in minutes."
  default = 30
}

variable "job_lenguage" {
  description = "Lenguage job"
  type = string
  default = "python"
}

variable "job_python_version" {
  description = "Python version of the job"
  type = string
  default = "3"
}

#-----------------------------------
# Others Variables
#-----------------------------------
variable "bucket_arns" {
   description = "ARN buckets"
   type        = map(string)
}

variable "bucket_job_scripts" {
  description = "Bucket scripts jobs"
  type = string
}

variable "cloudwatch_log_group_name" {
   description = "Name cloudwatch group log"
   type        = string
}

variable "folder_scripts_jobs" {
  description = "Job script folders"
  type        = string
}