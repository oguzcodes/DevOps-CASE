module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "mern-case-cluster"
  cluster_version = "1.30" # EKS'in en güncel ve stabil sürümlerinden biri

  # Dışarıdan kubectl ile bağlanabilmemiz için public access açık olmalı
  cluster_endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # OIDC, GitHub Actions üzerinden şifresiz/güvenli EKS bağlantısı için şarttır
  enable_irsa = true

  eks_managed_node_groups = {
    spot_nodes = {
      name = "spot-node-group"

      instance_types = ["t3.small", "t3.medium"]
      capacity_type  = "SPOT" # Maliyeti minimize eden sihirli kelime

      min_size     = 1
      desired_size = 2
      max_size     = 4

      # Düğümlerin (Nodes) diski. gp3 hem hızlıdır hem de gp2'den ucuzdur.
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 20
            volume_type           = "gp3"
            delete_on_termination = true
          }
        }
      }
    }
  }

  # AWS yetkilendirme (Senin bilgisayarından erişebilmen için)
  enable_cluster_creator_admin_permissions = true
}