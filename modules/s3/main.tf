# Sufijo para el nombre de los buckets
locals {
  s3-sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
}

# Creación de buckets (bronze, silver y gold)
resource "aws_s3_bucket" "datalake_buckets" {
  for_each = var.bucket_names
  bucket   =  "bk-${each.value}-${local.s3-sufix}"
  tags = {
    Name = each.value
  }
}

# Crear estructura de folders en los buckets
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
}

 # Encriptación en reposo
  resource "aws_s3_bucket_server_side_encryption_configuration" "server_encryption" {
    for_each = aws_s3_bucket.datalake_buckets
    bucket = each.value.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

 # Habilitar Control de versiones a la capa bronzezone
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

# Bucket para los script de JOB
resource "aws_s3_bucket" "bucket_scripts_jobs" {
  bucket   =  "bk-${var.bucket_scripts_jobs}-${local.s3-sufix}"
  tags = {
    Name = var.bucket_scripts_jobs
  }
}

# Subir los scripts de los jobs al bucket
resource "aws_s3_object" "bucket_objects_scripts" {
  for_each = var.scripts_jobs_path
  bucket = aws_s3_bucket.bucket_scripts_jobs.bucket
  key    = "scripts_jobs/${each.key}.py" 
  source = each.value
}
