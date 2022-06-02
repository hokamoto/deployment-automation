output "ip" {
  value = linode_instance.redpanda.*.ip_address
}

output "private_ips" {
  value = linode_instance.redpanda.*.private_ip_address
}

output "public_key_path" {
  value = var.public_key_path
}
