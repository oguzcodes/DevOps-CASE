module "ecr_frontend" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.0"
  repository_name         = "mern-frontend"
  repository_force_delete = true
  create_lifecycle_policy = false 
}

module "ecr_backend" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.0"
  repository_name         = "mern-backend"
  repository_force_delete = true
  create_lifecycle_policy = false 
}

module "ecr_python" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.0"
  repository_name         = "python-etl"
  repository_force_delete = true
  create_lifecycle_policy = false 
  
}