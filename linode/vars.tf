variable "linode_token" {
  description = "Linode APIv4 Personal Access Token"
}

variable "region" {
  default = "us-west"
}

variable "nodes" {
  description = "The number of nodes to deploy."
  type        = number
  default     = 3
}

variable "clients" {
  description = "Number of kafka client hosts to set up, if any."
  type        = number
  default     = 0
}

variable "disks" {
  description = "The number of local disks on each machine."
  type        = number
  default     = 1
}

variable "image" {
  default = "linode/ubuntu22.04"
}

variable "machine_type" {
  default = "g6-dedicated-2"
}

variable "monitor_machine_type" {
  description = "Instant type of the prometheus/grafana node"
  default     = "g6-dedicated-2"
}

variable "client_machine_type" {
  description = "Default client instance type to create"
  default     = "g6-standard-2"
}

variable "enable_monitoring" {
  description = "Setup a prometheus/grafana instance"
  default     = true
}

variable "public_key_path" {
  description = "The ssh key."
}
