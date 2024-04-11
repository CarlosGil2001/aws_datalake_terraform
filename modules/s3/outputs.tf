#----------------------------------------
# Output - ARN of buckets datalake
#---------------------------------------
locals {
  bucket_arns = {
    bronzezone = aws_s3_bucket.datalake_buckets["bronzezone"].arn
    silverzone = aws_s3_bucket.datalake_buckets["silverzone"].arn
    goldzone   = aws_s3_bucket.datalake_buckets["goldzone"].arn
  }
}
output "bucket_arns" {
  description = "ARN de los buckets"
  value       = local.bucket_arns
}
output "bronzezone_bucket_arn" {
  description = "ARN del bucket 'bronzezone'"
  value       = local.bucket_arns["bronzezone"]
}
output "silverzone_bucket_arn" {
  description = "ARN del bucket 'silverzone'"
  value       = local.bucket_arns["silverzone"]
}
output "goldzone_bucket_arn" {
  description = "ARN del bucket 'goldzone'"
  value       = local.bucket_arns["goldzone"]
}

#--------------------------------------------
# Output - Job Bucket name
#--------------------------------------------
output "bucket_job_scripts" {
  description = "Bucket de scripts job"
  value = aws_s3_bucket.bucket_scripts_jobs.bucket
}

#--------------------------------------------
# Output - Lambda Bucket name
#--------------------------------------------
output "bucket_lambda_scripts_name" {
  value = aws_s3_bucket.bucket_scripts_lambda.bucket
}

#--------------------------------------------
# Output - Lambda Bucket ARN
#--------------------------------------------
output "bucket_lambda_scripts_arn" {
  value = aws_s3_bucket.bucket_scripts_lambda.arn
}