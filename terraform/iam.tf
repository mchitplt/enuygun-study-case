resource "google_service_account" "gke_nodes_sa" {
  account_id   = "enuygun-gke-nodes-sa"
  display_name = "Enuygun GKE Nodes Service Account"
}