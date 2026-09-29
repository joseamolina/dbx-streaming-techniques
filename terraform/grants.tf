# databricks_grant (singular) only adds this principal's privileges and leaves
# other principals' grants untouched, which matters on the shared external location.

resource "databricks_grant" "catalog_deployer" {
  catalog    = databricks_catalog.main.name
  principal  = var.deployer_sp_application_id
  privileges = ["USE_CATALOG"]
}

resource "databricks_grant" "bronze_deployer" {
  schema     = databricks_schema.bronze.id
  principal  = var.deployer_sp_application_id
  privileges = ["USE_SCHEMA", "CREATE_TABLE", "SELECT", "MODIFY"]
}

resource "databricks_grant" "checkpoints_deployer" {
  volume     = databricks_volume.checkpoints.id
  principal  = var.deployer_sp_application_id
  privileges = ["READ_VOLUME", "WRITE_VOLUME"]
}

resource "databricks_grant" "sensors_location_deployer" {
  external_location = data.databricks_external_location.sensors.name
  principal         = var.deployer_sp_application_id
  privileges        = ["READ_FILES"]
}
