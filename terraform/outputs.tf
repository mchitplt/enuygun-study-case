output "cluster_name" {
  description = "Kurulan cluster'ın adı"
  value       = google_container_cluster.primary.name
}

output "kubectl_connection_command" {
  description = "Terminalinden cluster'a bağlanmak için kopyalaman gereken komut"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}