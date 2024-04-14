resource "aws_sfn_state_machine" "data_processing_workflow" {
  name          = "data_processing_workflow"
  role_arn      = var.step_function_role_arn
  definition    = <<EOF
{
  "Comment": "Data Processing Workflow",
  "StartAt": "RunCrawlerBronze",
  "States": {
    "RunCrawlerBronze": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:glue:startCrawler",
      "Parameters": {
        "Name": "dev_crw_bronzezone"
      },
      "Next": "RunLambdaBronze"
    },
    "RunLambdaBronze": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-uptable_br_glue",
      "Next": "RunETLJobSilver"
    },
    "RunETLJobSilver": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:glue:startJobRun",
      "Parameters": {
        "JobName": "dev_job_silverzone"
      },
      "Next": "RunCrawlerSilver"
    },
    "RunCrawlerSilver": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:glue:startCrawler",
      "Parameters": {
        "Name": "dev_crw_silverzone"
      },
      "Next": "RunLambdaSilver"
    },
    "RunLambdaSilver": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-uptable_sl_glue",
      "Next": "RunETLJobGold"
    },
    "RunETLJobGold": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:glue:startJobRun",
      "Parameters": {
        "JobName": "dev_job_goldzone"
      },
     "Next": "RunCrawlerGold"
    },
    "RunCrawlerGold": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:glue:startCrawler",
      "Parameters": {
        "Name": "dev_crw_goldzone"
      },
      "Next": "RunLambdaGold"
    },
    "RunLambdaGold": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:905418224712:function:lambda-uptable_gd_glue",
      "End": true
    }
  }
}
EOF
}
