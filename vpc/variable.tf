variable "project_name" {
  description = "Name of the project to be created in BluePlanet folder"
  type = string
}

variable "region" {
  description = "Google Cloud region"
  type = string
}

variable "gke_cluster_name" {
  description = "GKE cluster name to be created"
 type = string
}


variable "host-project-id" {
  description = "Provide shared vpc project id"
  type = string
}

variable "service-project-id-1" {
  description = "provide application project id"
  type = string
}

variable "ip_cidr_range" {
  description = "ip range"
  type = list(string)
}

variable "vpc_network" {
  description = "vpc name"
  type = string
}

variable "subnet_name" {
  description = "subnet name"
  type = string
}

