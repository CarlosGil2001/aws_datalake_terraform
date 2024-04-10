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

  variable "scripts_jobs_path" {
   description = "Nombre de los scripts"
   type        = map(string)
 }

# variable "csv_files_paths" {
#   description = "Rutas de los archivos CSV"
#   type        = map(string)
# }