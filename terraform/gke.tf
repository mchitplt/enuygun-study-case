resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
  node_locations = ["${var.region}-b"]

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet.id

  logging_service    = "none"
  monitoring_service = "none"

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }
  
  deletion_protection = false
}

resource "google_container_node_pool" "main_pool" {
  name           = "main-pool"
  location       = var.region
  cluster        = google_container_cluster.primary.name
  
  node_locations = ["${var.region}-b"]
  
  node_count     = 1

  node_config {
    machine_type    = "n2d-standard-2"
    service_account = google_service_account.gke_nodes_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_container_node_pool" "application_pool" {
  name               = "application-pool"
  location           = var.region
  cluster            = google_container_cluster.primary.name
  
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