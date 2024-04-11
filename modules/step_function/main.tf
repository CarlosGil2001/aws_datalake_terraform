# resource "aws_sfn_state_machine" "datalake_workflow" {
#   name     = "datalake-workflow"
#   role_arn = var.glue_rol_crw

#   definition = jsonencode({
#     Comment = "Flujo de trabajo para el procesamiento del Data Lake",
#     StartAt = "BronzeCrawler",
#     States = {
#       BronzeCrawler = {
#         Type    = "Task",
#         Resource = "crw_bronzezone",
#         Next    = "SilverJob"
#       },
#       SilverJob = {
#         Type    = "Task",
#         Resource = "job_silverzone",
#         Next    = "SilverCrawler"
#       },
#       SilverCrawler = {
#         Type    = "Task",
#         Resource = "crw_silverzone",
#         Next    = "GoldJob"
#       },
#       GoldJob = {
#         Type    = "Task",
#         Resource = "job_goldzone",
#         End     = true
#       }
#     }
#   })
# }

# # Define las políticas y roles necesarios para la ejecución de Step Functions
# resource "aws_iam_role" "stepfunctions_role" {
#   name = "stepfunctions-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect    = "Allow",
#       Principal = {
#         Service = "states.amazonaws.com"
#       },
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "stepfunctions_policy_attachment" {
#   role       = aws_iam_role.stepfunctions_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSStepFunctionsFullAccess"
# }