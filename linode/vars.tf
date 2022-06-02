variable "linode_token" {
  description = "Linode APIv4 Personal Access Token"
}

variable "region" {
  default = "us-west"
}

variable "nodes" {
  description = "The number of nodes to deploy."
  type        = number
  default     = "3"
}

variable "disks" {
  description = "The number of local disks on each machine."
  type        = number
  default     = 1
}

variable "image" {
  default = "linode/ubuntu18.04"
}

variable "machine_type" {
  default = "g6-dedicated-2"
}

variable "enable_monitoring" {
  description = "Setup a prometheus/grafana instance"
  default     = true
}

variable "public_key_path" {
  description = "The ssh key."
}
