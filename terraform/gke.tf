resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
  # KOTA SORUNUNU ÇÖZEN SATIR: Makineleri 3 zone'a yaymak yerine sadece 'b' zone'unda açar.
  node_locations = ["${var.region}-b"]

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet.id

  # Madde 1: Logging ve Monitoring disable edilmesi
  logging_service    = "none"
  monitoring_service = "none"

  # Google Best Practice: Varsayılan node havuzunu sil, bağımsız yönet
  remove_default_node_pool = true
  initial_node_count       = 1

  # VPC-Native IP Aliasing aktivasyonu
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }
  
  # Vakayı bitirince kolay silebilmen için korumayı kaldırıyoruz
  deletion_protection = false
}

# Madde 2: 1. Node Pool (main-pool)
resource "google_container_node_pool" "main_pool" {
  name           = "main-pool"
  location       = var.region
  cluster        = google_container_cluster.primary.name
  
  # KOTA SORUNUNU ÇÖZEN SATIR
  node_locations = ["${var.region}-b"]
  
  node_count     = 1

  node_config {
    machine_type    = "n2d-standard-2"
    service_account = google_service_account.gke_nodes_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# Madde 2: 2. Node Pool (application-pool)
resource "google_container_node_pool" "application_pool" {
  name               = "application-pool"
  location           = var.region
  cluster            = google_container_cluster.primary.name
  
  # KOTA SORUNUNU ÇÖZEN SATIR
  node_locations     = ["${var.region}-b"]
  
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type    = "n2d-standard-2"
    service_account = google_service_account.gke_nodes_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = {
      pool = "application-pool"
    }
  }
}