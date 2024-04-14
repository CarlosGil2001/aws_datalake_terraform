#-------------------------------------
# Rol - AWS Glue
#-------------------------------------

data "aws_iam_policy_document" "glue_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = var.type_principal
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue_service_role" {
  name               = var.role_glue_name
  description        = var.role_glue_description
  name_prefix        = var.role_glue_name_prefix
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role_policy.json

  tags = {
    "Name" = var.role_glue_name
  }

}

resource "aws_iam_policy" "glue_s3_data_catalog_policy" {
  name          = var.policy_glue_name
  description   = var.policy_glue_description
  name_prefix   = var.policy_glue_name_prefix
  policy        = data.aws_iam_policy_document.glue_s3_data_catalog_policy_document.json
}

data "aws_iam_policy_document" "glue_s3_data_catalog_policy_document" {
  statement {
    effect    = var.effect_policy
    actions   = var.policy_glue_s3_action
    resources = var.resource_policy #values(var.bucket_arns)
  }
  statement {
    effect    = var.effect_policy
    actions   = var.policy_glue_log_action
    resources = var.resource_policy
  }
  statement {
    effect    = var.effect_policy
    actions   = var.policy_glue_action
    resources = var.resource_policy # [var.database_arn]
  }
  statement {
    effect    = var.effect_policy
    actions   = var.policy_glue_encr_action
    resources = [var.database_arn]
  }
}

resource "aws_iam_role_policy_attachment" "glue_s3_data_catalog_policy_attachment" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.glue_s3_data_catalog_policy.arn
}

#---------------------------------------
# Rol - Amazon Lambda
#---------------------------------------
resource "aws_iam_role" "lambda_glue_role" {
  name               = var.role_lambda_name
  description        = var.role_lambda_description
  name_prefix        = var.role_lambda_name_prefix 
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  tags = {
    "Name" = var.role_lambda_name
  }

  inline_policy {
    name = var.policy_lambda_s3_name
    policy = jsonencode({
      Version = var.policy_version
      Statement = [
        {
          Effect    = var.effect_policy
          Action    = var.policy_lambda_s3_actions
          Resource  = var.resource_policy
        }
      ]
    })
  }
  inline_policy {
    name = var.policy_lambda_glue_name
    policy = jsonencode({
      Version = var.policy_version
      Statement = [
        {
          Effect   = var.effect_policy
          Action   = var.policy_lambda_glue_table_actions
          Resource = var.resource_policy #[var.database_arn]
        },
        {
          Effect   = var.effect_policy
          Action   = var.policy_lambda_glue_actions
          Resource = var.resource_policy #[var.database_arn]
        }
      ]
    })
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = var.effect_policy
    principals {
      type        = var.type_principal
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

#---------------------------------------
# Rol - AWS Step Function
#---------------------------------------
resource "aws_iam_role" "step_function_role" {
  name = "step_function_role"
  description = ""
  name_prefix = ""

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "states.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "step_function_policy_attachment" {
  name       = "step_function_policy_attachment"
  roles      = [aws_iam_role.step_function_role.name]
  policy_arn = aws_iam_policy.step_function_policy.arn
}

resource "aws_iam_policy" "step_function_policy" {
  name        = "step_function_policy"
  description = "Permisos para ejecutar AWS Glue Crawler, AWS Glue ETL Jobs y AWS Lambdas"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "glue:StartCrawler",
          "glue:StartJobRun",
          "lambda:InvokeFunction"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "step_function_policy_attachment" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = aws_iam_policy.step_function_policy.arn
}
