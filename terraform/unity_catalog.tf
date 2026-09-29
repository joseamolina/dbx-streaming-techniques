# The metastore has no storage root, so the catalog stores managed tables under
# the existing external location, in a prefix separate from the raw sensor files.
locals {
  catalog_storage_root = "s3://${var.sensor_bucket_name}/unity-catalog/${var.catalog_name}/"
}

resource "databricks_catalog" "main" {
  name          = var.catalog_name
  storage_root  = local.catalog_storage_root
  comment       = "Sensor streaming medallion layers. Managed by Terraform."
  force_destroy = false
}

resource "databricks_schema" "bronze" {
  catalog_name  = databricks_catalog.main.name
  name          = var.bronze_schema_name
  comment       = "Raw sensor readings ingested by Auto Loader."
  force_destroy = false
}

resource "databricks_volume" "checkpoints" {
  catalog_name = databricks_catalog.main.name
  schema_name  = databricks_schema.bronze.name
  name         = "checkpoints"
  volume_type  = "MANAGED"
  comment      = "Auto Loader checkpoints and schema locations."
}
