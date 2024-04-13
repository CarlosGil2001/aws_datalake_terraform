#-------------------------------------
# Module Amazon S3
#-------------------------------------
module "s3" {
  source       = "./modules/s3"
  bucket_names = var.bucket_names
  tags = var.tags
  folder_names_buckets  = var.folder_names_buckets
  bucket_scripts_jobs = var.bucket_scripts_jobs
  scripts_jobs_path = var.scripts_jobs_path
  folder_scripts_jobs = var.folder_scripts_jobs
  bucket_scripts_lambda = var.bucket_scripts_lambda
  folder_scripts_lambda = var.folder_scripts_lambda
  scripts_lambda_path = var.scripts_lambda_path
}

#----------------------------------------
# Module AWS Glue
#----------------------------------------
module "glue" {
  source = "./modules/glue"
  catalog_database_name= var.catalog_database_name
  tags = var.tags
  crawler_names = var.crawler_names
  bucket_arns = module.s3.bucket_arns
  glue_rol = module.iam.glue_rol
  job_names = var.job_names
  folder_scripts_jobs = var.folder_scripts_jobs
  bucket_job_scripts = module.s3.bucket_job_scripts
  cloudwatch_log_group_name = module.cloudwatch.cloudwatch_log_group_name
}

#----------------------------------------
# Module AWS IAM
#----------------------------------------
module "iam" {
  source = "./modules/iam"
  bucket_arns = module.s3.bucket_arns
  database_arn = module.glue.database_arn
  cloudwatch_log_group_arn = module.cloudwatch.cloudwatch_log_group_arn
}

#----------------------------------------
# Modulo Amazon CloudWatch
#----------------------------------------
module "cloudwatch" {
  source = "./modules/cloudwatch"
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
}

#----------------------------------------
# Amazon Lambda
#----------------------------------------
module "lambda" {
  source = "./modules/lambda"
  bucket_lambda_scripts_name = module.s3.bucket_lambda_scripts_name
  folder_scripts_lambda = var.folder_scripts_lambda
  bucket_lambda_scripts_arn = module.s3.bucket_lambda_scripts_arn
  scripts_lambda_path = var.scripts_lambda_path
  lambda_glue_rol_arn = module.iam.lambda_glue_rol_arn
}

module "step_function" {
     source = "./modules/step_function"
     crawler_arns         = tolist(values(module.glue.crawler_arns))
     job_arns             = module.glue.job_arns
     lambda_function_arns = tolist(values(module.lambda.lambda_function_arns))
   }