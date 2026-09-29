variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Servislerin oluşturulacağı GCP bölgesi"
  type        = string
}

variable "cluster_name" {
  description = "GKE Kümesinin adı"
  type        = string
}