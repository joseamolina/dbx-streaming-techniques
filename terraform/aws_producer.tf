# Lets the existing producer Lambda write sensor files and schedules it every minute.

resource "aws_iam_role_policy" "producer_s3_put" {
  name = "sensor-bucket-put"
  role = data.aws_iam_role.producer.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:PutObject"
      Resource = "${data.aws_s3_bucket.sensors.arn}/${var.sensor_prefix}*"
    }]
  })
}

resource "aws_iam_role" "producer_scheduler" {
  name = "${var.producer_function_name}-scheduler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "scheduler.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "producer_scheduler_invoke" {
  name = "invoke-producer"
  role = aws_iam_role.producer_scheduler.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "lambda:InvokeFunction"
      Resource = data.aws_lambda_function.producer.arn
    }]
  })
}

resource "aws_scheduler_schedule" "producer" {
  name                = "${var.producer_function_name}-every-minute"
  schedule_expression = "rate(1 minute)"
  state               = var.producer_enabled ? "ENABLED" : "DISABLED"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = data.aws_lambda_function.producer.arn
    role_arn = aws_iam_role.producer_scheduler.arn
  }
}
