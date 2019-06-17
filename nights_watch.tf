// Enabling GuardDuty

resource "aws_guardduty_detector" "nights_watch_detector" {
  enable = "true"
  finding_publishing_frequency = "ONE_HOUR"
}


// Creating the Cloudwatch Event Rule which monitors for new GuardDuty findings
resource "aws_cloudwatch_event_rule" "nights_watch" {
  name        = "nights_watch"

  event_pattern = <<PATTERN
{
  "source": [
      "aws.guardduty"
  ],
  "detail-type": [
      "GuardDuty Finding"
  ]
}
PATTERN
}

// Creating a target for the Cloudwatch rule that will send the results to a Lambda function
resource "aws_cloudwatch_event_target" "nights_watch" {
  rule      = "${aws_cloudwatch_event_rule.nights_watch.name}"
  target_id = "lambda"
  arn       = "${aws_lambda_function.nights_watch.arn}"
}

// Creating an IAM role that the Lambda function will be using
resource "aws_iam_role" "nights_watch_iam_role" {
  name = "nights_watch_iam"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// Creating the policy to allow Lambda to log to Cloudtrail
resource "aws_iam_policy" "nights_watch_lambda_logging" {
  name = "nights_watch_logging_policy"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

// Attaching the Lambda IAM role to the Lambda function
resource "aws_iam_role_policy_attachment" "nights_watch_lambda_logs" {
    role = "${aws_iam_role.nights_watch_iam_role.name}"
    policy_arn = "${aws_iam_policy.nights_watch_lambda_logging.arn}"
}

// Creating the Lambda function and grabbing our variables
resource "aws_lambda_function" "nights_watch" {
  filename      = "function.zip"
  function_name = "nights_watch_lambda"
  role          = "${aws_iam_role.nights_watch_iam_role.arn}"
  handler       = "main.lambda_handler"

  source_code_hash = "${filebase64sha256("function.zip")}"

  runtime = "python2.7"

  environment {
    variables = {
      slack_webhook = "${var.slack_webhook}",
      event_threshold = "${var.event_threshold}"
    }
  }
}

// Allowing CloudWatch events to start the lambda function
resource "aws_lambda_permission" "nights_watch" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.nights_watch.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.nights_watch.arn}"
}