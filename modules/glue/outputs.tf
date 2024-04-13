#-----------------------------------
# Output ARN AWS Glue Catalog
#-----------------------------------
output "database_arn" {
  description = "ARN Database Catalog"
  value = aws_glue_catalog_database.catalog_database.arn
}

#-----------------------------------
# Output ARN AWS Glue Crawler
#-----------------------------------
output "crawler_arns" {
  description = "ARNs of the Glue crawlers"
  value = {
    for idx, name in var.crawler_names : name => aws_glue_crawler.data_lake_crawler[idx].arn
  }
}

#-----------------------------------
# Output ARN AWS Glue Jobs
#-----------------------------------
output "job_arns" {
  description = "ARNS of the Glue jobs"
  value = {
    for name, job in aws_glue_job.glue_etl_jobs : name => job.arn
  }
}




