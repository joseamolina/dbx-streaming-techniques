variable "databricks_profile" {
  description = "Profile in ~/.databrickscfg for the target workspace."
  type        = string
  default     = "IDE"
}

variable "aws_region" {
  description = "Region of the sensor bucket and producer Lambda."
  type        = string
  default     = "us-east-1"
}

variable "catalog_name" {
  description = "Unity Catalog catalog that holds the medallion schemas."
  type        = string
  default     = "main"
}

variable "bronze_schema_name" {
  description = "Schema for the bronze layer."
  type        = string
  default     = "bronze"
}

variable "deployer_sp_application_id" {
  description = "Application ID of the service principal that deploys and runs prod (DATABRICKS_CLIENT_ID in GitHub)."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.deployer_sp_application_id))
    error_message = "deployer_sp_application_id must be a service principal application ID (UUID)."
  }
}

variable "external_location_name" {
  description = "Existing Unity Catalog external location that covers the sensor bucket."
  type        = string
  default     = "my_external_location"
}

variable "sensor_bucket_name" {
  description = "Existing S3 bucket the producer Lambda writes to."
  type        = string
  default     = "amz-prueba-s3-354452812509-us-east-1-an"
}

variable "sensor_prefix" {
  description = "Prefix under the sensor bucket where the Lambda writes JSON files."
  type        = string
  default     = "sensors/"
}

variable "producer_function_name" {
  description = "Existing Lambda that generates sensor readings."
  type        = string
  default     = "canary_heartbeat"
}

variable "producer_enabled" {
  description = "Whether the schedule that invokes the producer Lambda every minute is enabled."
  type        = bool
  default     = false
}
