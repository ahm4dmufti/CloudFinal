# CloudScale — Containerized Web App on Azure AKS with CI/CD

A DevOps final project: a containerized Node.js web app deployed to Azure
Kubernetes Service (AKS), with infrastructure provisioned by Terraform and an
automated CI/CD pipeline built with GitHub Actions (including a manual approval
gate for production).

## Team
- Ahmad El-Mufti
- Aya Abuoud
- Siraj ElFaitouri

## Architecture
Docker image → Azure Container Registry (ACR) → Azure Kubernetes Service (AKS).
GitHub Actions builds the image, pushes it to ACR, and deploys to AKS behind a
manual approval gate. Terraform provisions the Resource Group, ACR, and AKS.

## Tech Stack
- Node.js (zero-dependency HTTP server) + Docker
- Terraform (azurerm ~> 4.0)
- Azure: Resource Group, ACR (Basic), AKS (2 nodes)
- Kubernetes: Deployment (3 replicas), LoadBalancer Service, readiness & liveness probes
- GitHub Actions: build → push to ACR → manual approval → deploy to AKS

## Project Structure
\`\`\`
cloudscale-final/
├── app/server.js                  # the web application
├── Dockerfile                     # container definition
├── terraform/                     # Azure infrastructure as code
│   ├── providers.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
├── k8s/                           # Kubernetes manifests
│   ├── deployment.yaml
│   └── service.yaml
├── .github/workflows/ci-cd.yml    # CI/CD pipeline
└── .gitignore
\`\`\`

## Setup
### Prerequisites
Azure CLI, Docker, Terraform, kubectl

### 1. Provision infrastructure
\`\`\`bash
cd terraform
terraform init
# create terraform.tfvars with: subscription_id = "your-id"
terraform apply
\`\`\`

### 2. Build & push the image
\`\`\`bash
docker build -t cloudscale-app .
az acr login --name <your-acr>
docker tag cloudscale-app <your-acr>.azurecr.io/cloudscale-app:v1
docker push <your-acr>.azurecr.io/cloudscale-app:v1
\`\`\`

### 3. Deploy to AKS
\`\`\`bash
az aks get-credentials --resource-group <your-rg> --name <your-aks>
kubectl apply -f k8s/
kubectl get service cloudscale-app-service   # grab the EXTERNAL-IP
\`\`\`

### 4. CI/CD
Any push to \`main\` triggers the GitHub Actions pipeline: it builds and tests the
image, pushes it to ACR, then waits for manual approval before deploying to AKS.

## Cleanup
\`\`\`bash
cd terraform
terraform destroy
\`\`\`