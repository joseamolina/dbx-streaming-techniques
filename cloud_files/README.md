# cloud_files

## Getting Started

To deploy and manage this bundle, follow these steps:

### 1. Deployment

- Click the **deployment rocket** 🚀 in the left sidebar to open the **Deployments** panel, then click **Deploy**.

### 2. Running Jobs & Pipelines

- To run a deployed job or pipeline, hover over the resource in the **Deployments** panel and click the **Run** button.

### 3. Managing Resources

- Use the **Add** dropdown to add resources to the bundle.
- Click **Schedule** on a notebook within the bundle to create a **job definition** that schedules the notebook.

## Documentation

- For information on using **Declarative Automation Bundles in the workspace**, see: [Declarative Automation Bundles in the workspace](https://docs.databricks.com/aws/en/dev-tools/bundles/workspace-bundles)
- For details on the **Declarative Automation Bundles format** used in this bundle, see: [Declarative Automation Bundles Configuration reference](https://docs.databricks.com/aws/en/dev-tools/bundles/reference)

## CI/CD

Every push to `main` that touches `cloud_files/` (i.e. every merged PR) runs
[`.github/workflows/deploy-databricks.yml`](../.github/workflows/deploy-databricks.yml),
which validates the bundle and deploys the `prod` target. It authenticates with
GitHub OIDC as a service principal, so no Databricks secret is stored in GitHub.
The same service principal is the `run_as` identity for prod.

### One-time setup

1. In the Databricks account console, create a service principal and add it to
   the workspace. Note its **application ID**.
2. On that service principal, add a federation policy:
   - Issuer: `https://token.actions.githubusercontent.com`
   - Audiences: your Databricks account ID
   - Subject: `repo:joseamolina/dbx-streaming-techniques:environment:prod`
3. In GitHub, create the environment `prod` (Settings → Environments) with these variables:
   - `DATABRICKS_HOST` = `https://dbc-1e173d55-6b3b.cloud.databricks.com`
   - `DATABRICKS_CLIENT_ID` = the service principal's application ID
   - `DATABRICKS_ACCOUNT_ID` = your Databricks account ID (the federation policy's audience)

To validate prod locally, pass the service principal explicitly:

```bash
databricks bundle validate --strict -t prod --var prod_service_principal=<application-id>
```
