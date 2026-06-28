# A host project provides network resources to associated service projects.
resource "google_compute_shared_vpc_host_project" "host" {
  project = "host-project-id"
}

# A service project gains access to network resources provided by its
# associated host project.
resource "google_compute_shared_vpc_service_project" "service1" {
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = "service-project-id-1"
}

#resource "google_compute_shared_vpc_service_project" "service2" {
#  host_project    = google_compute_shared_vpc_host_project.host.project
#  service_project = "service-project-id-2"
#}

resource "google_compute_subnetwork" "som-subnet" {
  name          = "var.subnet_name"
  ip_cidr_range = "var.ip_cidr_range"
  region        = "var.region"
  network       = google_compute_network.custom-test.id
}

resource "google_compute_network" "som-vpc" {
  name                    = "var.vpc_network"
  auto_create_subnetworks = false
}





