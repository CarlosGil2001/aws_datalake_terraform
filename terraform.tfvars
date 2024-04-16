#-----------------------------------------
#  Global variable values
#-----------------------------------------
tags = {
  "env" = "dev"
  "owner" = "Carlos e Isac"
  "cloud" = "AWS"
  "IAC" = "Terraform"
  "IAC_Version" = "1.7"
  "project" = "project1"
  "region" = "useast1"
}

bucket_names= ["bronzezone", "silverzone", "goldzone"]

folder_names_buckets= ["sales", "customer", "jobs"]

catalog_database_name = "aws_data"
 
crawler_names = ["bronzezone", "silverzone", "goldzone"]

bucket_scripts_jobs = "gluejobs"

job_names = ["job_silverzone", "job_goldzone"]

folder_scripts_jobs = "scripts_jobs"

folder_scripts_lambda = "scripts_lambda"

scripts_lambda_path = {
  "update_tables_glue" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/lambdas/update_tables_glue/update_tables_glue.zip"
  "run_crawlers" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/lambdas/run_crawlers/run_crawlers.zip"
  "run_jobs" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/lambdas/run_jobs/run_jobs.zip"
  "event_s3" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/lambdas/event_s3/event_s3.zip"
}

bucket_scripts_lambda = "lambdafunctions"

cloudwatch_log_group_name = "cloudwatch_log_group"