output "cluster_name" {
  description = "EKS Cluster Adı"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Control Plane Endpoint'i"
  value       = module.eks.cluster_endpoint
}

output "update_kubeconfig_command" {
  description = "Kümeye bağlanmak için terminalde çalıştırılacak komut"
  value       = "aws eks update-kubeconfig --region eu-central-1 --name ${module.eks.cluster_name}"
}