#-------------------------------------
# Rol - AWS Glue
#-------------------------------------
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
  name               = "AWSGlueRole"
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
      "glue:GetTable",
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

#---------------------------------------
# Rol - Amazon Lambda
#---------------------------------------
resource "aws_iam_role" "lambda_glue_rol" {
  name               = "lambda_glue_rol"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  inline_policy {
    name = "lambda-s3-access"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:ListBucket"
          ]
          Resource = ["*"] 
         # [
            #"arn:aws:s3:::${var.bucket_lambda_scripts_name}/*",
            #"arn:aws:s3:::${var.bucket_lambda_scripts_name}"
         # ]
        }
      ]
    })
  }

  inline_policy {
    name = "lambda-glue-access"
    policy = jsonencode({
      Version   = "2012-10-17",
      Statement = [{
        Effect   = "Allow",
        Action   = [
          "glue:GetTable",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:DeleteTable"
        ],
        Resource = "*"
      }]
    })
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}