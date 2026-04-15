# Operational Runbook: Demo App

## Incident Response Context

This guide is intended for an on-call engineer to quickly diagnose and remediate issues with the Python/Fargate deployment.

## Rollback Methods

If a new deployment causes health check failures or application errors:

### AWS Native Rollback (Fastest)

If the deployment hung or failed during the rollout, the ECS Deployment Circuit Breaker should have triggered automatically. If it didn't:

1. Open the ECS Console: [Link to ECS Service Dashboard] 
2. Update Service: Select the dev-service, click Update.
3. Rollback: Select the previous stable Task Definition Revision from the dropdown.
4. Force Deployment: Check "Force new deployment" to immediately replace unhealthy tasks.

### Terraform Revert (for infrastructure)

Use this if the infrastructure itself (Security Groups, ALB) is broken and needs to be returned to a known good state.

1. Locate Previous Tag: Find the last successful image tag in GitHub Action logs or the main branch commit history.
2. Targeted Apply: Execute from the environments/dev/ directory to avoid affecting other modules:
   ```
      # Verify the plan first to ensure no other 'drifts' are applied
      terraform plan -var="container_image=<PREVIOUS_TAG>"

      # Apply the specific rollback
      terraform apply -var="container_image=<PREVIOUS_TAG>" -auto-approve
   ```

### Git Revert (slower, but more permanent)

Once the immediate fire is out, ensure the repository reflects reality to prevent "roll-forward" bugs.
1.  Revert PR: Go to the faulty Pull Request and click **Revert**.
2.  Merge: Merge the revert PR to `main`.
3.  Monitor: This triggers the GitHub Actions workflow to re-deploy the last known stable code.

## Troubleshooting: Credential Issues

If the GitHub Action fails during terraform init or plan with "AccessDenied" or "No valid credentials":
1. Verify Repository Secrets: Ensure AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are still valid and haven't rotated or been deactivated.
2. Check IAM Permissions: Confirm the IAM user associated with the keys has the necessary permissions (PowerUser or AdministratorAccess for this demo).
3. Local Testing: To rule out GitHub Actions issues, attempt a plan locally using a fresh terminal session with the credentials exported manually.

## Verification of Traffic Routing

If the ALB is not routing traffic to the app:
1. Target Group Health: Check the AWS Console (EC2 -> Target Groups -> Demo-TG). Ensure targets are "Healthy."
   - If "Unhealthy": Check the CloudWatch Log Group `/ecs/dev-app` for application startup errors.
2. Security Groups: Verify the ECS security group allows ingress from the ALB security group on port 8080.
3. ALB DNS: Run a curl command against the ALB DNS name:
   ```bash
   curl -v http://<alb-dns-name>/
   ```
   A successful response should return `{"status":"healthy","environment":"dev"}`.

## Resource Scaling

To scale the service manually in an emergency:
1. Update the `desired_count` in the `modules/compute/main.tf` file.
2. Alternatively, perform a manual override via AWS CLI:
   ```bash
   aws ecs update-service --cluster dev-cluster --service dev-service --desired-count 2
   ```
## Escalation

Escalation Path:

- Primary: @DevOps-OnCall (Slack)
- Secondary: #eng-infrastructure-alerts
- Application Lead: @arnav.jose
