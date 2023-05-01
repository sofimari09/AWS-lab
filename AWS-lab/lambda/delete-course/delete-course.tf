data "aws_arn" "course-table" {
  arn = "arn:aws:dynamodb:eu-central-1:204505241771:table/dev-course"
}

resource "aws_iam_role_policy" "delete-course-lambda-policy" {
  name = "${var.name}-lambda-policy"
  role = aws_iam_role.delete-course-lambda-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : "dynamodb:DeleteItem",
        "Resource" : data.aws_arn.course-table.id
    }]
  })
}

resource "aws_iam_role" "delete-course-lambda-role" {
  name = "${var.name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com"
          ]
        }
      },
    ]
  })
}


data "archive_file" "delete-course-lambda" {
  type        = "zip"
  source_file = "${path.module}/${var.name}-lambda.js"
  output_path = "${path.module}/${var.name}-lambda.zip"
}

resource "aws_lambda_function" "delete-course-lambda" {

  filename      = "${path.module}/${var.name}-lambda.zip"
  function_name = "${var.name}-lambda"
  role          = aws_iam_role.delete-course-lambda-role.arn
  handler       = "${var.name}-lambda.handler"
  runtime = "nodejs12.x"
}
