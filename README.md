# Hello World — Automated Kubernetes Deployment on AWS EKS

## Overview

This project demonstrates a complete DevOps CI/CD pipeline that builds, containerizes, and deploys a Node.js application to a managed Kubernetes cluster on AWS.

Every push to the `main` branch triggers an automated workflow that:

- Builds a Docker image
- Scans it for vulnerabilities using Trivy
- Pushes the image to Amazon ECR
- Deploys it to Amazon EKS using Helm

The entire infrastructure is provisioned using Terraform with a modular design.

## Tech Stack

| Layer | Tool |
|---|---|
| Application | Node.js + Express |
| Containerization | Docker |
| Infrastructure as Code | Terraform |
| Kubernetes | Amazon EKS |
| Container Registry | Amazon ECR |
| CI/CD | GitHub Actions |
| Packaging | Helm |
| Security Scanning | Trivy |
| Observability | Amazon CloudWatch (Fluent Bit + CloudWatch Agent) |

## Architecture Flow

```
GitHub Push → GitHub Actions
           → Docker Build
           → Trivy Scan
           → Push to ECR
           → Helm Deploy
           → EKS Cluster
           → LoadBalancer URL
```
## Repository Structure

```
hello-world/
├── app/
│   ├── index.js
│   ├── package.json
│   ├── Dockerfile
│   └── .dockerignore
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── modules/
│       ├── vpc/
│       ├── ecr/
│       └── eks/
│
├── helm/
│   └── hello-world/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── cwagent-fluent-bit.yaml
├── screenshots/
└── README.md
```

## Prerequisites

Install and configure the following tools before getting started:

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with credentials
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/) >= 3.x
- [Docker](https://docs.docker.com/get-docker/)

## Setup Instructions

### 1. Clone the Repository

```
git clone https://github.com/<your-username>/hello-world.git
cd helloapp
```

### 2. Provision Infrastructure with Terraform

```
cd terraform

terraform init
terraform plan
terraform apply
```

This provisions:

- VPC with 2 public subnets
- Internet Gateway and routing
- EKS cluster with a managed node group
- ECR repository

### 3. Configure kubectl

```
aws eks update-kubeconfig --region ap-south-1 --name hello-world-eks
```

Verify nodes are ready:

```
kubectl get nodes
```

### 4. Configure GitHub Secrets

Go to **GitHub → Settings → Secrets and variables → Actions** and add:

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |
| `ECR_REGISTRY` | ECR repository URL |
| `EKS_CLUSTER_NAME` | EKS cluster name |

### 5. Trigger the CI/CD Pipeline

Any push to `main` triggers the full deployment:

```
git add .
git commit -m "trigger deployment"
git push origin main
```

The pipeline will automatically:

1. Build the Docker image
2. Scan with Trivy for CRITICAL vulnerabilities
3. Push the image to ECR
4. Deploy to EKS via Helm

### 6. Get the Application URL

```
kubectl get svc -n hello-world
```
Open the URL/External IP in your browser to see the live application.

---

## Design Decisions

### Modular Terraform

Infrastructure is split into three focused modules — `vpc`, `ecr`, and `eks`. This improves reusability, maintainability, and keeps each concern isolated and easy to extend independently.

### Public Subnets — No NAT Gateway

Worker nodes are deployed in public subnets to simplify networking for a demo environment and avoid unnecessary NAT Gateway overhead. In production, workloads would be placed in private subnets with controlled outbound access via NAT or VPC endpoints.

### Docker Optimisation

- Uses `node:18-alpine` as the base image (~50MB vs ~900MB for the full image)
- Only production dependencies installed via `npm install --omit=dev`
- `.dockerignore` prevents local `node_modules` from polluting the build context

### Helm-based Deployment

Helm is used to parameterise deployments and inject the image repository and tag dynamically at deploy time via `--set` flags. This avoids manual YAML edits per release and makes the chart reusable across environments.

### Git SHA Image Tagging

Each Docker image is tagged with the Git commit SHA (`github.sha`). This ensures every deployment is immutable and fully traceable back to an exact commit, avoiding the ambiguity of mutable tags like `latest`.

### Security with Trivy

Trivy scans the container image before it is pushed to ECR. The pipeline fails on `CRITICAL` severity vulnerabilities, acting as a security gate. `ignore-unfixed: true` prevents failures on vulnerabilities with no available fix, reducing noise.

### Observability with CloudWatch

Basic observability is implemented using Amazon CloudWatch, Fluent Bit, and the CloudWatch Agent. Fluent Bit ships container logs from EKS nodes to CloudWatch Log Groups, and the CloudWatch Agent collects cluster and node-level metrics — providing visibility into application logs and infrastructure health without third-party tooling.

### LoadBalancer over Ingress

A Kubernetes `LoadBalancer` service is used instead of an Ingress controller. For a single application, this is simpler — AWS automatically provisions an ELB without needing to install and manage a separate Ingress controller.

---

## CI/CD Pipeline Summary

The GitHub Actions pipeline performs the following steps on every push to `main`:

1. Checkout code
2. Configure AWS credentials
3. Login to Amazon ECR
4. Build Docker image
5. Scan image with Trivy
6. Push image to ECR
7. Update kubeconfig for EKS
8. Deploy with Helm

---

## Live Application

> **URL:** http://a91a2e42f47ef4e4d899595f1976d2fb-1355400003.ap-south-1.elb.amazonaws.com/

---

## Screenshots

Available in the `/screenshots` folder. Includes:

- CI/CD pipeline runs
- CloudWatch logs and metrics
- Live application UI
- Kubernetes resources
