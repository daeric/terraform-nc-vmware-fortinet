terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.2.0"
    }
    fortios = {
      source  = "fortinetdev/fortios"
      version = "1.16.0"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_vcenter
  allow_unverified_ssl = true
}

locals {
  templatevars = {
    name         = var.hostname,
    public_key   = var.public_key,
    ssh_username = var.ssh_username
  }
}

# Define VMware vSphere 
data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Cluster01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "Ubuntu-2204-Template-100GB-Thin"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.hostname
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus             = var.cpu
  num_cores_per_socket = var.cores-per-socket
  memory               = var.ram
  guest_id             = "ubuntu64Guest"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "${var.hostname}-disk"
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    size             = var.disksize == "" ? data.vsphere_virtual_machine.template.disks.0.size : var.disksize 
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/templates/metadata.yaml", local.templatevars))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/templates/userdata.yaml", local.templatevars))
    "guestinfo.userdata.encoding" = "base64"
  }
  lifecycle {
    ignore_changes = [
      annotation,
      clone[0].template_uuid,
      clone[0].customize[0].dns_server_list,
      clone[0].customize[0].network_interface[0]
    ]
  }
}

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