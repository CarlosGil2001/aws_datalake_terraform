#-------------------------------
# CloudWatch
#-------------------------------
variable "cloudwatch_log_group_name" {
  description = "(Optional, Forces new resource) The name of the log group"
  type = string
}
variable "cloudwatch_retention_in_days" {
  description = "Optional) Specifies the number of days you want to retain log events in the specified log group."
  default = 7
}
variable "cloudwatch_name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix."
  type = string
  default = null
}
variable "cloudwatch_log_group_class" {
  description = "(Optional) Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS"
  type = string
  default = null
}
