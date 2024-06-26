#----------------------------------
# AWS Glue Data Catalog
#---------------------------------
resource "aws_glue_catalog_database" "catalog_database" {
  name          = "${var.tags.env}_${var.catalog_database_name}"
  description   = var.catalog_database_description
  
  catalog_id    = var.catalog_database_catalog_id
  location_uri  = var.catalog_database_location_uri
  parameters    = var.catalog_database_parameters

  tags = {
    Name  = var.catalog_database_name
  }
}

#----------------------------------------------
# Suffix for crawlers names
#----------------------------------------------
locals {
  suffixed_crawler_names = [for name in var.crawler_names : "${var.tags.env}_crw_${name}"]
}

#---------------------------------
# AWS Glue crawlers
#---------------------------------
resource "aws_glue_crawler" "data_lake_crawler" {
  count          = length(local.suffixed_crawler_names)
  name           = local.suffixed_crawler_names[count.index]
  database_name  = aws_glue_catalog_database.catalog_database.name
  role           = var.glue_role

  description    = var.crawler_description
  classifiers    = var.crawler_classifiers  
  configuration = jsonencode(var.crawler_configuration)
  schedule       = var.crawler_schedule
  table_prefix   = var.crawler_table_prefix

  s3_target {
    path = "s3://${regex("arn:aws:s3:::(.+)", lookup(var.bucket_arns, substr(local.suffixed_crawler_names[count.index], 8, -1), ""))[0]}/jobs"
  }
   depends_on = [ var.glue_role, aws_glue_catalog_database.catalog_database]
 }

#-----------------------------------------
# AWS Glue ETL Jobs
#-----------------------------------------
resource "aws_glue_job" "glue_etl_jobs" {
  for_each = var.job_names
  name     = "${var.tags.env}_${each.value}"
  role_arn = var.glue_role

  description       = var.job_description
  glue_version      = var.job_glue_version
  max_capacity      = var.job_max_capacity
  max_retries       = var.job_max_retries
  execution_class   = var.job_execution_class
  worker_type       = var.job_worker_type
  number_of_workers = var.job_number_of_workers
  timeout           = var.job_timeout

  command {
     script_location  = "s3://${var.bucket_job_scripts}/${var.folder_scripts_jobs}/${each.key}.py"
     python_version   = var.job_python_version
  }

  tags = {
    Name = each.value
  }

  default_arguments = {
    "--job-language"                     = var.job_lenguage
    "--continuous-log-logGroup"          = var.cloudwatch_log_group_name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
  }

  depends_on = [ var.glue_role, var.cloudwatch_log_group_name ]
}





