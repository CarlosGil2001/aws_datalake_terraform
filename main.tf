
module "s3" {
  source       = "./modules/s3"
  bucket_names = var.bucket_names
  tags = var.tags
  folder_names_buckets  = var.folder_names_buckets
  bucket_scripts_jobs = var.bucket_scripts_jobs
  scripts_jobs_path = var.scripts_jobs_path
}

module "glue" {
  source = "./modules/glue"
  catalog_database_name= var.catalog_database_name
  crawler_names = var.crawler_names
  bucket_arns = module.s3.bucket_arns
  glue_rol_crw = module.iam.glue_rol_crw
  etl_jobs_names = var.etl_jobs_names
  bucket_job_scripts = module.s3.bucket_job_scripts
}

module "iam" {
  source = "./modules/iam"
  bucket_arns = module.s3.bucket_arns
  database_arn = module.glue.database_arn
}