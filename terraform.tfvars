tags = {
  "env" = "dev"
  "owner" = "Carlos e Isac"
  "cloud" = "AWS"
  "IAC" = "Terraform"
  "IAC_Version" = "1.7"
  "project" = "project1"
  "region" = "useast1"
}

# Nombre de los bk para el datalake
bucket_names= ["bronzezone", "silverzone", "goldzone"]

# Nombre de folders de los bk
folder_names_buckets= ["sales", "customer", "jobs"]

# csv_files_paths={
#     "ordenes"      = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/data/ordenes-202403.csv"
#     "proveedores"   = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/data/proveedores-202403.csv"
#     "entidades"    = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/data/entidades-202403.csv"
#   }

catalog_database_name = "aws_data"
 
crawler_names = ["bronzezone", "silverzone", "goldzone"]
bucket_scripts_jobs = "gluejobs"
job_names = ["job_silverzone", "job_goldzone"]
scripts_jobs_path = {
  "job_silverzone" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/jobs/job_silverzone.py"
  "job_goldzone" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/jobs/job_goldzone.py"
}
folder_scripts_jobs = "scripts_jobs"
folder_scripts_lambda = "scripts_lambda"
scripts_lambda_path = {
  "uptable_br_glue" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/lambdas/uptable_br_glue/uptable_br_glue.zip"
  "uptable_sl_glue" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/lambdas/uptable_sl_glue/uptable_sl_glue.zip"
  "uptable_gd_glue" = "C:/Users/carlo/Desktop/Projects Terraform/charla_aws/lambdas/uptable_gd_glue/uptable_gd_glue.zip"
}

bucket_scripts_lambda = "lambdafunctions"
cloudwatch_log_group_name = "cloudwatch_log_group"