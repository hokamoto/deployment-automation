resource "linode_instance" "redpanda" {
  region          = var.region
  count           = var.nodes
  label           = "rp-node-${count.index}"
  tags            = ["rp-cluster"]
  type            = var.machine_type
  image           = var.image
  authorized_keys = [chomp(file(var.public_key_path))]
  private_ip      = true
}

resource "local_file" "hosts_ini" {
  content = templatefile("${path.module}/../templates/hosts_ini.tpl",
    {
      redpanda_public_ips  = linode_instance.redpanda.*.ip_address
      redpanda_private_ips = linode_instance.redpanda.*.private_ip_address
      monitor_public_ip    = []
      monitor_private_ip   = []
      client_public_ips    = []
      client_private_ips   = []
      ssh_user             = "root"
      enable_monitoring    = false
    }
  )
  filename = "${path.module}/../hosts.ini"
}
