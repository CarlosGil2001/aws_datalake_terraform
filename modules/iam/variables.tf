#--------------------------------------
# IAM Module Variables
#--------------------------------------

variable "effect_policy" {
  description = "Effect of policies."
  type        = string
  default     = "Allow"
}

variable "resource_policy" {
  description = "Policy resources"
  type        = list(string)
  default     = [ "*" ]
}

variable "policy_version" {
  description = "Policy version"
  type        =  string
  default     = "2012-10-17"
}

variable "type_principal" {
  description = "Type principal"
  type        =  string
  default     = "Service"
}

#--------------------------------------
# IAM Rol Glue
#--------------------------------------
variable "role_glue_name" {
  description = "Friendly name of the role."
  type        = string
  default     = "AWSGlueRole"
}

variable "role_glue_description" {
  description = "(Optional) Description of the role."
  type        = string
  default     = "Glue Rol"
}

variable "role_glue_name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique friendly name beginning with the specified prefix."
  type        = string
  default     = null
}

#----------------------------------------
# IAM Policy Glue
#----------------------------------------
variable "policy_glue_name" {
  description = "Name of the policy."
  type        = string
  default     = "GlueS3AndDataCatalogPolicy"
}

variable "policy_glue_description" {
  description = "(Optional, Forces new resource) Description of the IAM policy."
  type        = string
  default     = "Glue rol policy"
}

variable "policy_glue_name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix."
  type        = string
  default     = null
}

variable "policy_glue_s3_action" {
  description = "Glue role policy actions with S3."
  type = list(string)
  default = ["s3:GetObject","s3:PutObject","s3:ListBucket","cloudwatch:PutMetricData"]
}

variable "policy_glue_log_action" {
  description = "Glue role policy actions with logs."
  type = list(string)
  default = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
}

variable "policy_glue_action" {
  description = "Glue role policy actions with glue."
  type = list(string)
  default = ["glue:CreateTable","glue:GetTable","glue:GetDatabase","glue:BatchGetPartition","glue:BatchCreatePartition", "glue:GetPartitions"]
}
#
variable "policy_glue_encr_action" {
  description = "Glue role policy actions with encryption."
  type = list(string)
  default = ["glue:GetDataCatalogEncryptionSettings"]
}


#--------------------------------------
# IAM Rol Lambda
#--------------------------------------
variable "role_lambda_name" {
  description = "Friendly name of the role."
  type        = string
  default     = "AWSLambdaRole"
}

variable "role_lambda_description" {
  description = "(Optional) Description of the role."
  type        = string
  default     = "Lambda Rol"
}

variable "role_lambda_name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique friendly name beginning with the specified prefix."
  type        = string
  default     = null
}

#--------------------------------------
# IAM Policy Lambda
#--------------------------------------
variable "policy_lambda_s3_name" {
  description = "Policy name with access to S3."
  type        = string
  default     = "lambda-s3-access"
}

variable "policy_lambda_s3_actions" {
  description = "Policy actions with access to S3."
  type        = list(string)
  default     = ["s3:GetObject","s3:ListBucket", "s3:PutObject"]
}

variable "policy_lambda_glue_name" {
  description = "Policy name with access to glue."
  type        = string
  default     = "lambda-glue-access"
}

variable "policy_lambda_glue_actions" {
  description = "Policy actions with access to glue."
  type        = list(string)
  default     = ["glue:CreateTable", "glue:UpdateTable", "glue:DeleteTable"]
}

variable "policy_lambda_glue_table_actions" {
  description = "Policy actions with access to glue table."
  type        = list(string)
  default     =  ["glue:GetTable"]
}

#-------------------------------------
# Other Variables
#-------------------------------------
variable "bucket_arns" {
   description = "ARN buckets datalake"
   type        = map(string)
 }

variable "database_arn" {
   description = "ARN Data Catalog"
   type        =  string
 }

variable "cloudwatch_log_group_arn" {
   description = "ARN cloudwatch group log"
   type        = string
}