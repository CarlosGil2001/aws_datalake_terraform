#---------------------------------------------
# Suffix for the name of the buckets
#---------------------------------------------
locals {
  s3-sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
}

#---------------------------------------------------
# Buckets (bronze, silver y gold)
#---------------------------------------------------
resource "aws_s3_bucket" "datalake_buckets" {
  for_each    = var.bucket_names
  bucket      = "bk-${each.value}-${local.s3-sufix}"
  tags = {
    Name = each.value
  }
  force_destroy = true
  
  lifecycle {
    prevent_destroy = false
  }
}

#---------------------------------------------------
# Event S3
#---------------------------------------------------

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = var.lambda_permission_not
  action        = var.lambda_permission_not_action
  function_name = var.lambda_function_arns[0]
  principal     = var.lambda_permission_not_principal
  source_arn    = aws_s3_bucket.datalake_buckets["bronzezone"].arn

  depends_on = [ aws_s3_bucket.datalake_buckets ]
}

resource "aws_s3_bucket_notification" "bucket_bronze_notification" {
  bucket = aws_s3_bucket.datalake_buckets["bronzezone"].id
  lambda_function {
    lambda_function_arn = var.lambda_function_arns[0]
    events              = var.s3_notification_lambda_event
    filter_prefix       = "jobs/"
    filter_suffix       = ".csv"
  }
  depends_on = [ aws_s3_bucket.datalake_buckets, var.lambda_function_arns ]
}

#------------------------------------------------------
# Folder structure datalake
#-----------------------------------------------------
resource "aws_s3_object" "structure_buckets" {
  for_each = {
    for pair in setproduct(var.bucket_names, var.folder_names_buckets) : "${pair[0]}-${pair[1]}" => {
      bucket_name = pair[0]
      folder_name = pair[1]
    }
  }
  bucket  = aws_s3_bucket.datalake_buckets[each.value.bucket_name].bucket
  key     = "${each.value.folder_name}/"
  content = null

  depends_on = [ aws_s3_bucket.datalake_buckets ]
}

#---------------------------------------
# Encryption at rest
#---------------------------------------
  resource "aws_s3_bucket_server_side_encryption_configuration" "server_encryption" {
    for_each  = aws_s3_bucket.datalake_buckets
    bucket    = each.value.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.type_encrypted
      }
    }
  }

#--------------------------------------
# Enable Version Control
#--------------------------------------
resource "aws_s3_bucket_versioning" "versioning_buckets" {
  for_each = {
    for bucket_name in var.bucket_names :
    bucket_name => bucket_name
  }
  bucket = aws_s3_bucket.datalake_buckets[each.key].id

  versioning_configuration {
    status = each.key == "bronzezone" ? "Enabled" : "Suspended"
  }
}

#-------------------------------------
# Bucket for glue job scripts
#--------------------------------------
resource "aws_s3_bucket" "bucket_scripts_jobs" {
  bucket   =  "bk-${var.bucket_scripts_jobs}-${local.s3-sufix}"
  tags = {
    Name = var.bucket_scripts_jobs
  }
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

#-----------------------------------------------
# Job scripts
#-----------------------------------------------
resource "aws_s3_object" "bucket_objects_scripts" {
  for_each  = var.scripts_jobs_path
  bucket    = aws_s3_bucket.bucket_scripts_jobs.bucket
  key       = "${var.folder_scripts_jobs}/${each.key}.py" 
  source    = "${path.root}${each.value}"

  depends_on = [ aws_s3_bucket.bucket_scripts_jobs ]

}

#--------------------------------------
# Bucket for lambda scripts
#--------------------------------------
resource "aws_s3_bucket" "bucket_scripts_lambda" {
  bucket   =  "bk-${var.bucket_scripts_lambda}-${local.s3-sufix}"
  tags = {
    Name = var.bucket_scripts_lambda
  }
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

#-------------------------------------------------
# Lambda scripts
#-------------------------------------------------
resource "aws_s3_object" "bucket_objects_scripts_lambda" {
  for_each  = var.scripts_lambda_path
  bucket    = aws_s3_bucket.bucket_scripts_lambda.bucket
  key       = "${var.folder_scripts_lambda}/${each.key}.zip" 
  source    = "${path.root}${each.value}"

  depends_on = [ aws_s3_bucket.bucket_scripts_lambda ]
}

#-------------------------------------------------
# Upload Data
#-------------------------------------------------
resource "aws_s3_object" "upload_object_data" {
  bucket    =  aws_s3_bucket.datalake_buckets["bronzezone"].id
  key       = "jobs/${var.upload_object_data_s3}" 
  source    = "${path.root}${var.upload_object_data_s3_location}/${var.upload_object_data_s3}"

  depends_on = [aws_s3_bucket_notification.bucket_bronze_notification, 
                var.step_function_name]
}



