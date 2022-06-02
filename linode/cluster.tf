resource "linode_instance" "redpanda" {
  region          = var.region
  count           = var.nodes
  label           = "rp-node-${count.index}"
  group           = "rp-cluster"
  tags            = ["rp-cluster"]
  type            = var.machine_type
  image           = var.image
  authorized_keys = [chomp(file(var.public_key_path))]
  private_ip      = true
}

resource "linode_instance" "monitor" {
  region          = var.region
  count           = var.enable_monitoring ? 1 : 0
  label           = "rp-monitor"
  group           = "rp-cluster"
  tags            = ["rp-cluster"]
  type            = var.monitor_machine_type
  image           = var.image
  authorized_keys = [chomp(file(var.public_key_path))]
  private_ip      = true
}

resource "linode_instance" "client" {
  region          = var.region
  count           = var.clients
  label           = "rp-client"
  group           = "rp-client"
  tags            = ["rp-client"]
  type            = var.client_machine_type
  image           = var.image
  authorized_keys = [chomp(file(var.public_key_path))]
  private_ip      = true
}

resource "linode_firewall" "redpanda_firewall" {
  label = "rp-firewall"
  tags  = ["rp-cluster"]

  inbound {
    label    = "allow"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22, 9092, 33145, 9644, 3000, 9090, 9100"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  linodes = var.enable_monitoring ? concat(linode_instance.redpanda.*.id, [linode_instance.monitor[0].id]) : linode_instance.redpanda.*.id
}

resource "local_file" "hosts_ini" {
  content = templatefile("${path.module}/../templates/hosts_ini.tpl",
    {
      redpanda_public_ips  = linode_instance.redpanda.*.ip_address
      redpanda_private_ips = linode_instance.redpanda.*.private_ip_address
      monitor_public_ip    = var.enable_monitoring ? linode_instance.monitor[0].ip_address : ""
      monitor_private_ip   = var.enable_monitoring ? linode_instance.monitor[0].private_ip_address : ""
      client_public_ips    = linode_instance.client.*.ip_address
      client_private_ips   = linode_instance.client.*.private_ip_address
      ssh_user             = "root"
      enable_monitoring    = var.enable_monitoring
    }
  )
  filename = "${path.module}/../hosts.ini"
}
