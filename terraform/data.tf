# Resources created outside Terraform. Read only, never managed here.

data "databricks_external_location" "sensors" {
  name = var.external_location_name
}

data "aws_s3_bucket" "sensors" {
  bucket = var.sensor_bucket_name
}

data "aws_lambda_function" "producer" {
  function_name = var.producer_function_name
}

data "aws_iam_role" "producer" {
  name = element(split("/", data.aws_lambda_function.producer.role), length(split("/", data.aws_lambda_function.producer.role)) - 1)
}
