
variable slack_webhook {}
variable event_threshold {
  default = "0"
}
variable iam_role {}


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


// Creating the Lambda function and grabbing our variables
resource "aws_lambda_function" "nights_watch" {
  filename      = "function.zip"
  function_name = "nights_watch_lambda"
  role          = "${var.iam_role}"
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