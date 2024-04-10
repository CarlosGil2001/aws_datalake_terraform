# Crear AWS Glue Data Catalog
resource "aws_glue_catalog_database" "catalog_database" {
  name = var.catalog_database_name
  tags = {
    Name = var.catalog_database_name
  }
}

# Sufijo para los nombre de los crawlers
locals {
  suffixed_crawler_names = [for name in var.crawler_names : "crw_${name}"]
}

# Crear crawlers
 resource "aws_glue_crawler" "data_lake_crawler" {
   count          = length(local.suffixed_crawler_names)
   name           = local.suffixed_crawler_names[count.index]
   database_name  = aws_glue_catalog_database.catalog_database.name
   role           = var.glue_rol_crw

   s3_target {
     path = "s3://${regex("arn:aws:s3:::(.+)", lookup(var.bucket_arns, substr(local.suffixed_crawler_names[count.index], 4, -1), ""))[0]}"
   }
   table_prefix = "${local.suffixed_crawler_names[count.index]}_"
 }


# Crear grupo de log de CloudWatch
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "cloudwatch_log_group"
  retention_in_days = 7
}

# Crear ETL Jobs apuntando a los scripts
resource "aws_glue_job" "glue_etl_jobs" {
   for_each = var.etl_jobs_names
   name     = each.value
   role_arn = var.glue_rol_crw

   command {
     script_location = "s3://${var.bucket_job_scripts}/scripts_jobs/${each.key}.py"
   }
  tags = {
    Name = each.value
  }

  # Habilitar de registros y métricas de CloudWatch
  default_arguments = {
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.cloudwatch_log_group.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
  }
  # Descripción de jobs
   description = "Job that consumes data from the data lake S3"
  # Tipo de worker
   worker_type = "G.1X"
   # de workers
   number_of_workers = 2
   # tiempo max de ejecución
   timeout = 30
 }
