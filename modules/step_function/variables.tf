#--------------------------------------
# Step Function Module Variables
#--------------------------------------
variable "step_function_name" {
  description = "The name of the state machine. "
  type        = string
  default     = "processing_workflow"
}

variable "step_function_role_arn" {
   description = "ARN rol step function."
   type        = string
}

variable "step_function_name_prefix" {
   description = "(Optional) Creates a unique name beginning with the specified prefix."
   type        = string
   default     = null
}

#--------------------------------------
# Others Variables
#--------------------------------------
variable "crawler_arns" {
  description = "ARN crawlers."
  type        = list(string)
}

variable "job_arns" {
  description = "ARN jobs."
  type = map(string)
}

variable "lambda_function_arns" {
  description = "ARN lambdas."
  type = list(string)
}

