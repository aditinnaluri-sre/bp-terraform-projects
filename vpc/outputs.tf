output "vpc_id" {
  value = google_compute_network.shared_vpc.id
}

output "subnet_id" {
  value = google_compute_subnetwork.gke_subnet.id
}

output "subnet_self_link" {
  value = google_compute_subnetwork.gke_subnet.self_link
}

output "pods_range_name" {
  value = "pods"
}

output "services_range_name" {
  value = "services"
}
