provider "databricks" {
  profile = var.databricks_profile
}

# Credentials come from AWS_PROFILE.
provider "aws" {
  region = var.aws_region
}
