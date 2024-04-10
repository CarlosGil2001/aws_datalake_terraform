variable "catalog_database_name" {
  description = "Database Catalog"
  type        = string
}
variable "bucket_arns" {
   description = "ARN de los buckets"
   type        = map(string)
 }

variable "crawler_names" {
  description = "Crawlers"
  type = list(string)
}

variable "glue_rol_crw" {
  description = "Rol de Glue para los Crawlers"
  type = string
}

variable "etl_jobs_names" {
  description = "Nombre de los Jobs"
  type = set(string)
}

variable "bucket_job_scripts" {
  description = "Bucket de scripts"
  type = string
}