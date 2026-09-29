# terraform

Infrastructure for the sensor streaming project. Terraform owns the infrastructure;
the Databricks bundle in `../cloud_files` owns notebooks and jobs.

| Managed here | Read only (created outside Terraform) |
|---|---|
| Catalog `main`, schema `bronze`, volume `checkpoints` | External location `my_external_location` |
| Grants for the deployer service principal | S3 bucket `amz-prueba-s3-354452812509-us-east-1-an` |
| Lambda S3 write policy, EventBridge Scheduler schedule | Lambda `canary_heartbeat` and its IAM role |

State is stored in `s3://tfstate-354452812509-us-east-1/dbx-streaming-techniques/terraform.tfstate`
with S3 native locking.

## Usage

```bash
# Terraform can't read `aws login` profiles directly, so export the session credentials.
eval "$(aws configure export-credentials --profile canary_heartbeat --format env)"
./bootstrap-state-bucket.sh          # once (already done)
cp terraform.tfvars.example terraform.tfvars   # set deployer_sp_application_id
terraform init
terraform plan -out=plan.tfplan
terraform apply plan.tfplan
```

`deployer_sp_application_id` is the Application ID of the `github-deployer` service
principal (`DATABRICKS_CLIENT_ID` in GitHub). Look it up with
`databricks service-principals list --profile IDE`. The all-zeros placeholder in the
example passes validation, so check the principal in the plan before applying.

The producer schedule is created disabled. Set `producer_enabled = true` to start
writing a sensor file every 3 seconds (the Lambda runs every minute).

`terraform output` prints `source_path`, `checkpoint_path` and `target_table` for the
bronze notebook.
