# Operational Runbook: Demo App

## Incident Response Context
This guide is intended for an on-call engineer to quickly diagnose and remediate issues with the Python/Fargate deployment.

## 1. Rollback Procedure
If a new deployment causes health check failures or application errors:
1. Identify the previous stable image tag: Locate the image tag from the last successful GitHub Actions run or by checking the ECS Task Definition in the AWS Console.
   <console link for the application>
2. Manual Revert via Terraform:
   - Navigate to `environments/dev/` locally.
   - Run terraform apply with the specific image tag:
     ```bash
     terraform apply -var="container_image=demo-app:PREVIOUS_TAG"
     ```
3. GitHub Actions Revert: If the issue was a code commit, revert the pull request in GitHub. This will trigger a new build and deploy with the previous version.

## 2. Troubleshooting: Credential Issues
If the GitHub Action fails during terraform init or plan with "AccessDenied" or "No valid credentials":
1. Verify Repository Secrets: Ensure AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are still valid and haven't rotated or been deactivated.
2. Check IAM Permissions: Confirm the IAM user associated with the keys has the necessary permissions (PowerUser or AdministratorAccess for this demo).
3. Local Testing: To rule out GitHub Actions issues, attempt a plan locally using a fresh terminal session with the credentials exported manually.

## 3. Verification of Traffic Routing
If the ALB is not routing traffic to the app:
1. Target Group Health: Check the AWS Console (EC2 -> Target Groups -> Demo-TG). Ensure targets are "Healthy."
   - If "Unhealthy": Check the CloudWatch Log Group `/ecs/dev-app` for application startup errors.
2. Security Groups: Verify the ECS security group allows ingress from the ALB security group on port 8080.
3. ALB DNS: Run a curl command against the ALB DNS name:
   ```bash
   curl -v http://<alb-dns-name>/
   ```
   A successful response should return `{"status":"healthy","environment":"dev"}`.

## 4. Resource Scaling
To scale the service manually in an emergency:
1. Update the `desired_count` in the `modules/compute/main.tf` file.
2. Alternatively, perform a manual override via AWS CLI:
   ```bash
   aws ecs update-service --cluster dev-cluster --service dev-service --desired-count 2
   ```
