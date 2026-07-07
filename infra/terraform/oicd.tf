
# 1. DevOps Best Practice: Least Privilege (En Az Ayrıcalık) Politikası
resource "aws_iam_policy" "github_actions_policy" {
  name        = "mern-case-github-actions-policy"
  description = "Policy for GitHub Actions to access only specific ECRs and EKS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        # ECR'a giriş yapabilmek için genel yetki
        Sid      = "GetAuthorizationToken",
        Effect   = "Allow",
        Action   = ["ecr:GetAuthorizationToken"],
        Resource = "*"
      },
      {
        # SADECE bizim oluşturduğumuz 3 depoya imaj atabilme yetkisi
        Sid      = "AllowPushToSpecificECR",
        Effect   = "Allow",
        Action   = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = [
          module.ecr_frontend.repository_arn,
          module.ecr_backend.repository_arn,
          module.ecr_python.repository_arn
        ]
      },
      {
        # SADECE bizim EKS kümemizin bilgilerini çekme yetkisi
        Sid      = "AllowEKSDescribe",
        Effect   = "Allow",
        Action   = ["eks:DescribeCluster"],
        Resource = module.eks.cluster_arn
      }
    ]
  })
}

# 2. GitHub Actions'ın kullanacağı IAM Rolü
module "iam_github_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "~> 5.0"
  
  name = "mern-case-github-actions-role"

  subjects = ["oguzcodes/DevOps-CASE:*"]

  policies = {
    LeastPrivilegePolicy = aws_iam_policy.github_actions_policy.arn
  }
}

# 3. KUBERNETES KİMLİK DOĞRULAMASI: Bu AWS rolünün K8s içine API isteği atabilmesi için Access Entry
resource "aws_eks_access_entry" "github_actions" {
  cluster_name  = module.eks.cluster_name
  principal_arn = module.iam_github_oidc_role.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_actions" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = module.iam_github_oidc_role.arn
  access_scope {
    type = "cluster"
  }
}

# Terminale bu rolün ARN'sini yazdıracak
output "github_actions_role_arn" {
  description = "GitHub Secrets'a AWS_ROLE_ARN olarak eklenecek değer"
  value       = module.iam_github_oidc_role.arn
}
 