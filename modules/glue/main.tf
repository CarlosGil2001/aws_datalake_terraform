#----------------------------------
# AWS Glue Data Catalog
#---------------------------------
resource "aws_glue_catalog_database" "catalog_database" {
  name = "${var.tags.env}_${var.catalog_database_name}"
  description = var.catalog_database_description
  
  catalog_id = var.catalog_database_catalog_id
  location_uri = var.catalog_database_location_uri
  parameters = var.catalog_database_parameters

  tags = {
    Name = var.catalog_database_name
  }
}

#----------------------------------------------
# Sufijo para los nombre de los crawlers
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
  role           = var.glue_rol

  description    = var.crawler_description
  classifiers    = var.crawler_classifiers  
  configuration  = var.crawler_configuration
  schedule       = var.crawler_schedule
  table_prefix   = var.crawler_table_prefix

   s3_target {
     path = "s3://${regex("arn:aws:s3:::(.+)", lookup(var.bucket_arns, substr(local.suffixed_crawler_names[count.index], 8, -1), ""))[0]}"
   }
   depends_on = [ var.glue_rol, aws_glue_catalog_database.catalog_database ]
 }

#-----------------------------------------
# AWS Glue ETL Jobs
#-----------------------------------------
resource "aws_glue_job" "glue_etl_jobs" {
  for_each = var.job_names
  name     = "${var.tags.env}_${each.value}"
  role_arn = var.glue_rol

  description = var.job_description
  glue_version = var.job_glue_version
  max_capacity = var.job_max_capacity
  max_retries = var.job_max_retries
  execution_class = var.job_execution_class
  worker_type = var.job_worker_type
  number_of_workers = var.job_number_of_workers
  timeout = var.job_timeout

  command {
     script_location = "s3://${var.bucket_job_scripts}/${var.folder_scripts_jobs}/${each.key}.py"
  }

  tags = {
    Name = each.value
  }

  default_arguments = {
    "--job-language" = var.job_lenguage
    "--continuous-log-logGroup"          = var.cloudwatch_log_group_name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
  }

  depends_on = [ var.glue_rol, var.cloudwatch_log_group_name ]
 }

# # Worflow
#  resource "aws_glue_workflow" "example" {
#    name = "example-workflow"
#  }

#  # Trigger para iniciar el flujo de trabajo con el crawler de bronzezone
#  resource "aws_glue_trigger" "start_bronzezone_crawler" {
#    name         = "trigger-start-bronzezone-crawler"
#    type         = "ON_DEMAND"
#    workflow_name = aws_glue_workflow.example.name

#    actions {
#      crawler_name = "crw_bronzezone"
#    }
#  }

# # # Trigger condicional para ejecutar el job de silverzone después del crawler de bronzezone
#  resource "aws_glue_trigger" "silverzone_job" {
#    name         = "trigger-silverzone-job"
#    type         = "CONDITIONAL"
#    workflow_name = aws_glue_workflow.example.name

#    predicate {
#      conditions {
#        crawler_name = "crw_bronzezone"
#        state        = "SUCCEEDED"
#      }
#    }

#    actions {
#      job_name = "job_silverzone"
#    }
#  }


# # Trigger condicional para ejecutar el crawler de silverzone después del job de silverzone
#  resource "aws_glue_trigger" "silverzone_crawler" {
#    name         = "trigger-silverzone-crawler"
#    type         = "CONDITIONAL"
#    workflow_name = aws_glue_workflow.example.name

#    predicate {
#      conditions {
#        job_name = "job_silverzone"
#        state    = "SUCCEEDED"
#      }
#    }

#    actions {
#      crawler_name = "crw_silverzone"
#    }
#  }

# # # Trigger condicional para ejecutar el job de goldzone después del crawler de silverzone
#  resource "aws_glue_trigger" "goldzone_job" {
#    name         = "trigger-goldzone-job"
#    type         = "CONDITIONAL"
#    workflow_name = aws_glue_workflow.example.name

#    predicate {
#      conditions {
#        crawler_name = "crw_silverzone"
#        state        = "SUCCEEDED"
#      }
#    }

#    actions {
#      job_name = "goldzone"
#    }
#  }





