#----------------------------------------
# Output - ARN Glue Role
#----------------------------------------
output "glue_role" {
  description   = "ARN Glue Role"
  value         = aws_iam_role.glue_service_role.arn
}

#----------------------------------------
# Output - ARN Lambda Rol
#----------------------------------------
output "lambda_glue_role_arn" {
  description   = "ARN Lambda Role"
  value         = aws_iam_role.lambda_glue_role.arn
}

#----------------------------------------
# Output - ARN Step Function Rol
#----------------------------------------
output "step_function_role_arn" {
  description   = "Step Function Role"
  value         = aws_iam_role.step_function_role.arn
}