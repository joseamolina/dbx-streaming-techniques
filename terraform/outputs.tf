output "source_path" {
  description = "Auto Loader source path for the bronze notebook."
  value       = "s3://${data.aws_s3_bucket.sensors.bucket}/${var.sensor_prefix}"
}

output "checkpoint_path" {
  description = "Auto Loader checkpoint path for the bronze notebook."
  value       = "${databricks_volume.checkpoints.volume_path}/sensor_data/"
}

output "target_table" {
  description = "Bronze Delta table written by the notebook."
  value       = "${databricks_catalog.main.name}.${databricks_schema.bronze.name}.sensor_data"
}
