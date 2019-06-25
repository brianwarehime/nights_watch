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

output "iam_role" {
  value = "${aws_iam_role.nights_watch_iam_role.arn}"
}