#---------------------------------------------
# Suffix for the name of the buckets
#---------------------------------------------
locals {
  s3-sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
}

#---------------------------------------------------
# Buckets (bronze, silver y gold)
#--------------------------------------------------
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
  source    = each.value

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
  source    = each.value

  depends_on = [ aws_s3_bucket.bucket_scripts_lambda ]
}

#---------------------------------------------------
# Bucket Athena
#--------------------------------------------------
resource "aws_s3_bucket" "bucket_athena" {
  bucket      = "bk-${var.bucket_athena}-${local.s3-sufix}"
  tags = {
    Name = var.bucket_athena
  }
  force_destroy = true
  
  lifecycle {
    prevent_destroy = false
  }
  
}
