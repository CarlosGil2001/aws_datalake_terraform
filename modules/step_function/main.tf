resource "aws_sfn_state_machine" "data_processing_workflow" {
  name     = "data_processing_workflow"
  role_arn = aws_iam_role.step_function_role.arn
  definition = <<EOF
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

# Define el rol IAM
resource "aws_iam_role" "step_function_role" {
  name = "step_function_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Adjunta la política de ejecución del Step Function al rol IAM
resource "aws_iam_policy_attachment" "step_function_policy_attachment" {
  name       = "step_function_policy_attachment"
  roles      = [aws_iam_role.step_function_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSStepFunctionsFullAccess"
}