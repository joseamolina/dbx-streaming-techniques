# terraform/

See [README.md](README.md) for what is managed here versus read only.

## Rules

- Plan, never apply. Save the plan with `-out=plan.tfplan` and hand it to the user.
- Resources created outside Terraform are `data` sources in `data.tf`. Never turn one
  into a `resource` or `import` it without being asked.
- Grants use `databricks_grant` (singular), never `databricks_grants`: the plural
  resource removes every other principal's grants on shared objects.
- New variables get a `description`, a `type`, and a `validation` when a bad value
  would still pass type checking.
- `terraform.tfvars` is gitignored. Add new variables to `terraform.tfvars.example`.

## Credentials

The AWS CLI uses `aws login` sessions, which Terraform cannot read. Export them first:

```bash
eval "$(aws configure export-credentials --format env)"
```

Databricks uses profile `IDE` from `~/.databrickscfg` (`var.databricks_profile`).

State: `s3://tfstate-354452812509-us-east-1/dbx-streaming-techniques/terraform.tfstate`,
S3 native locking.
