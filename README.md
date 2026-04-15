# Demo Engineering Take-Home Assignment

## Project Overview

This repository contains a modular Terraform project to deploy a sample Python application on AWS using ECS Fargate.
The architecture is designed for high availability and low operational overhead.

### Application Choice (what and why)

I am deploying a containerized Python Flask API.
It serves a JSON health check endpoint (/) that echoes back the current environment name.
This was chosen specifically for Demo Reliability as it allows us to verify that the Load Balancer,
ECS Service, and Environment Variables are all correctly wired up with a single curl command.

### System Architecture

The infrastructure follows a High-Availability (HA) Cloud-Native pattern:

- VPC & Networking: A custom VPC with Public and Private subnets across two Availability Zones.
- Public Layer: An Application Load Balancer (ALB) sits in the public subnets to handle ingress.
- Private Layer: The Python app runs on AWS Fargate in private subnets. It has no direct internet exposure, following security best practices.
- Security: Communication is restricted via Security Group chaining; the Fargate tasks only accept traffic from the ALB's security group."

### Usage

 CI/CD with GitHub Actions

- This project uses a unified pipeline in .github/workflows/main.yml.
- Triggering: The workflow runs on every push to main, every Pull Request, or can be manually triggered via workflow_dispatch.
- Environment Selection: When triggering manually, you can select the target environment (dev vs prd).
- Secrets: uses AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY from GitHub Repository Secrets for the terraform plan to authenticate.
- Feedback: On Pull Requests, the workflow automatically comments the terraform plan output directly onto the PR for peer review.


### Trade-offs
- No Remote Backend: Using local state to avoid the chicken-and-egg problem of infrastructure setup for a 2-4 hour task,
  and prevent unnecessary creation of any chargeable AWS resources.
- NAT Gateway Toggle: In dev, the NAT Gateway is optional to save costs, whereas in prod it is mandatory for security/updates.
- Mocked ECR: We validate the Docker build but skip the push to avoid requiring a live registry for the demo.

## Future Improvements (Production Roadmap)
1. OIDC Provider: Transition from long-lived AWS IAM User Secrets to GitHub Actions OIDC for short-lived, identity-based credentials.
2. Remote State: Implement an S3 backend with DynamoDB locking for team-based state management.
3. Real ECR Integration: Replace the mock push with a real ECR repository and image scanning (Amazon Inspector) for vulnerability detection.
4. Auto-scaling: Add App Auto Scaling policies based on CPU/Memory utilization for the Fargate service.

## Project Structure
```
├── app                  # python flask application & Dockerfile
├── environments         # environment-specific configurations (dev/prod)
├── modules              # reusable terraform modules (networking, compute, etc)
├── README.md            # architecture & how-tos
├── RUNBOOK.md           # operational guide
└── TEAM_UPDATE.md       # slack communication sample
```

## Getting Started locally
1. Install [Terraform](https://developer.hashicorp.com/terraform/downloads).
2. Navigate to `environments/dev/`.
3. Initialize and plan:
   ```bash
   terraform init
   terraform plan
   ```
