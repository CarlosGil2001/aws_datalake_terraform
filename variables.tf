variable "tags" {
  description = "Tags del proyecto"
  type = map(string)
}

variable "bucket_names" {
  description = "Nombres de los buckets de S3"
  type        = set(string)
}

variable "folder_names_buckets" {
  description = "Nombres de los folders en los buckets"
  type        = list(string)

}

# variable "csv_files_paths" {
#   description = "Rutas de los archivos CSV"
#   type        = map(string)
# }

variable "catalog_database_name" {
  description = "Nombre de Database Catalog"
  type        = string
}

variable "crawler_names" {
  description = "Crawler"
  type = list(string)
}

 variable "bucket_scripts_jobs" {
   description = "Buckets de los scripts jobs"
   type        = string
 }

 variable "etl_jobs_names" {
  description = "Nombre de los Jobs"
  type = set(string)
}

  variable "scripts_jobs_path" {
   description = "Path de los scripts"
   type        = map(string)
 }