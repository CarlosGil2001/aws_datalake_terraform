
# Definir política de confianza
data "aws_iam_policy_document" "glue_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}
# Crear ROL y asignarle la política de confianza
resource "aws_iam_role" "glue_service_role" {
  name               = "AWSGlueCrwRole"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role_policy.json
}

resource "aws_iam_policy" "glue_s3_and_data_catalog_policy" {
  name   = "GlueS3AndDataCatalogPolicy"
  policy = data.aws_iam_policy_document.glue_s3_and_data_catalog_policy_document.json
}

# Crear política de IAM personalizada
data "aws_iam_policy_document" "glue_s3_and_data_catalog_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "cloudwatch:PutMetricData",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = values(var.bucket_arns)
  }

  statement {
    effect = "Allow"
    actions = [
      "glue:CreateTable",
      "glue:GetDatabase",
      "glue:GetDataCatalogEncryptionSettings"
    ]
    resources = [var.database_arn]
  }
}

# Adjuntar la política personalizada al rol
resource "aws_iam_role_policy_attachment" "glue_s3_and_data_catalog_policy_attachment" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.glue_s3_and_data_catalog_policy.arn
}