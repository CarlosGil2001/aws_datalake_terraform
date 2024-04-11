output "glue_rol" {
  value = aws_iam_role.glue_service_role.arn
}

output "lambda_glue_rol_arn" {
  value = aws_iam_role.lambda_glue_rol.arn
}