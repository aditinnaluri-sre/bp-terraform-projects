variable "host_project_id" {
  description = "Shared VPC Host Project ID"
  type        = string
}

variable "service_project_id" {
  description = "GKE Service Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "vpc_name" {
  description = "VPC Network Name"
  type        = string
  default     = "vpc-shared"
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
  default     = "subnet-gke"
}

variable "subnet_cidr" {
  description = "Primary subnet CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "pods_cidr" {
  description = "GKE Pods secondary CIDR"
  type        = string
  default     = "10.1.0.0/16"
}

variable "services_cidr" {
  description = "GKE Services secondary CIDR"
  type        = string
  default     = "10.2.0.0/16"
}
