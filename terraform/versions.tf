terraform {
  required_version = ">= 1.10"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.134"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.66"
    }
  }

  # State bucket is created once by bootstrap-state-bucket.sh.
  # Credentials come from AWS_PROFILE, like the aws provider.
  backend "s3" {
    bucket       = "tfstate-354452812509-us-east-1"
    key          = "dbx-streaming-techniques/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
