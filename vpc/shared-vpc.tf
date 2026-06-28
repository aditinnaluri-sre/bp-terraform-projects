# ── 1. Enable Shared VPC on Host Project ──────────────────────────────────────
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project_id
}

# ── 2. Attach Service Project to Host ─────────────────────────────────────────
resource "google_compute_shared_vpc_service_project" "gke_service" {
  host_project    = var.host_project_id
  service_project = var.service_project_id
  depends_on      = [google_compute_shared_vpc_host_project.host]
}

# ── 3. VPC Network (in Host Project) ──────────────────────────────────────────
resource "google_compute_network" "shared_vpc" {
  name                    = var.vpc_name
  project                 = var.host_project_id
  auto_create_subnetworks = false
  depends_on              = [google_compute_shared_vpc_host_project.host]
}

# ── 4. Subnet with Secondary Ranges for GKE ───────────────────────────────────
resource "google_compute_subnetwork" "gke_subnet" {
  name          = var.subnet_name
  project       = var.host_project_id
  region        = var.region
  network       = google_compute_network.shared_vpc.id
  ip_cidr_range = var.subnet_cidr

  # GKE requires secondary ranges for pods and services
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }

  private_ip_google_access = true
}

# ── 5. Share Subnet with Service Project ──────────────────────────────────────
resource "google_compute_subnetwork_iam_binding" "gke_subnet_binding" {
  project    = var.host_project_id
  region     = var.region
  subnetwork = google_compute_subnetwork.gke_subnet.name
  role       = "roles/compute.networkUser"

  members = [
    "serviceAccount:${data.google_project.service_project.number}@cloudservices.gserviceaccount.com",
    "serviceAccount:service-${data.google_project.service_project.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
}

# ── 6. Grant container.hostServiceAgentUser on Host Project ───────────────────
resource "google_project_iam_member" "gke_host_agent" {
  project = var.host_project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:service-${data.google_project.service_project.number}@container-engine-robot.iam.gserviceaccount.com"
}

# ── 7. Firewall Rules ─────────────────────────────────────────────────────────
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  project = var.host_project_id
  network = google_compute_network.shared_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [
    var.subnet_cidr,
    var.pods_cidr,
    var.services_cidr
  ]
}

resource "google_compute_firewall" "allow_gke_master" {
  name    = "allow-gke-master"
  project = var.host_project_id
  network = google_compute_network.shared_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["443", "10250"]
  }

  # GKE master CIDR — update this after GKE cluster is created
  source_ranges = ["172.16.0.0/28"]
  target_tags   = ["gke-node"]
}

# ── Data Sources ──────────────────────────────────────────────────────────────
data "google_project" "service_project" {
  project_id = var.service_project_id
}
