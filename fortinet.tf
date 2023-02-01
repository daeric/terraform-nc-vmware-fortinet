provider "fortios" {
  hostname = var.fortigate_ip
  token    = var.fortigate_api_token
  insecure = "true"
}

resource "fortios_firewall_address" "myvmaddress" {
  name                 = vsphere_virtual_machine.vm.name
  subnet               = "${vsphere_virtual_machine.vm.guest_ip_addresses[0]}/32"
  type                 = "ipmask"
  associated_interface = "lan"
  visibility           = "enable"
}