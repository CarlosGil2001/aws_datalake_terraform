#----------------------------------------
# Output - Step Function
#---------------------------------------
output "step_function_name" {
  description   = "Step Function Name"
  value         = aws_sfn_state_machine.data_processing_workflow.name
}