# infrastructure/terraform/providers.tf

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1" # Frankfurt (Kendine en yakın/uygun bölgeyi seçebilirsin)
  
  default_tags {
    tags = {
      Project     = "MERN-DevOps-Case"
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}