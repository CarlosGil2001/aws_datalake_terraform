#--------------------------------------
# Step Function - Workflow
#--------------------------------------
resource "aws_sfn_state_machine" "data_processing_workflow" {
  name          = var.step_function_name
  role_arn      = var.step_function_role_arn
  name_prefix   = var.step_function_name_prefix

  tags = {
    "Name" : var.step_function_name
  }

  depends_on = [ var.crawler_arns, 
                 var.job_arns, 
                 var.lambda_function_arns, 
                 var.step_function_role_arn,
                 var.step_function_name ]

  definition    = <<EOF
{
  "Comment": "Data Processing Workflow",
  "StartAt": "RunCrawlerBronze",
  "States": {
    "RunCrawlerBronze": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-run_crawlers",
      "Parameters": {
        "crawler_name": "dev_crw_bronzezone"
      },
      "Next": "UpdateTableBronze"
    },
    "UpdateTableBronze": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-update_tables_glue",
      "Parameters": {
        "old_table_name": "jobs",
        "new_table_name": "ds_salaries_br"
      },
      "Next": "RunETLJobSilver"
    },
    "RunETLJobSilver": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-run_jobs",
      "Parameters": {
        "job_name": "dev_job_silverzone"
      },
      "Next": "ValidateJobSilver"
    },
    "ValidateJobSilver": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$",
          "StringEquals": "{\"validation_result\": \"success\"}",
          "Next": "RunCrawlerSilver"
        },
        {
          "Variable": "$.validation_result",
          "StringEquals": "failure",
          "Next": "JobFailed"
        }
      ],
      "Default": "RunCrawlerSilver"
    },
    "JobFailed": {
      "Type": "Fail",
      "Error": "Validation failed",
      "Cause": "The validation step did not pass."
    },
    "RunCrawlerSilver": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-run_crawlers",
      "Parameters": {
        "crawler_name": "dev_crw_silverzone"
      },
      "Next": "UpdateTableSilver"
    },
    "UpdateTableSilver": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-update_tables_glue",
      "Parameters": {
        "old_table_name": "jobs",
        "new_table_name": "ds_salaries_sl"
      },
      "Next": "RunETLJobGold"
    },
    "RunETLJobGold": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-run_jobs",
      "Parameters": {
        "job_name": "dev_job_goldzone"
      },
      "Next": "ValidateJobGold"
    },
    "ValidateJobGold": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$",
          "StringEquals": "{\"validation_result\": \"success\"}",
          "Next": "RunCrawlerGold"
        },
        {
          "Variable": "$.validation_result",
          "StringEquals": "failure",
          "Next": "JobFailed"
        }
      ],
      "Default": "RunCrawlerGold"
    },
    "RunCrawlerGold": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-run_crawlers",
      "Parameters": {
        "crawler_name": "dev_crw_goldzone"
      },
      "Next": "UpdateTableGold"
    },
    "UpdateTableGold": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-update_tables_glue",
      "Parameters": {
        "old_table_name": "jobs",
        "new_table_name": "ds_salaries_gd"
      },
      "End": true
    }
  }
}
EOF
}
