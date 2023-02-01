#===========================#
# VMware vCenter connection #
#===========================#

variable "vsphere_user" {
  type        = string
  description = "VMware vSphere user name"
  sensitive   = true
}

variable "vsphere_password" {
  type        = string
  description = "VMware vSphere password"
  sensitive   = true
}

variable "vsphere_vcenter" {
  type        = string
  description = "VMWare vCenter server FQDN / IP"
  sensitive   = true
}

variable "vsphere-unverified-ssl" {
  type        = string
  description = "Is the VMware vCenter using a self signed certificate (true/false)"
  default     = "true"
}

variable "vsphere-datacenter" {
  type        = string
  description = "VMWare vSphere datacenter"
  default     = "Datacenter"
}

variable "vsphere-cluster" {
  type        = string
  description = "VMWare vSphere cluster"
  default     = "Cluster01"
}

variable "vsphere-template-folder" {
  type        = string
  description = "Template folder"
  default     = "Templates"
}

#================================#
# VMware vSphere virtual machine #
#================================#

variable "name" {
  type        = string
  description = "The name of the vSphere virtual machines and the hostname of the machine"
}

variable "vm-datastore" {
  type        = string
  description = "Datastore used for the vSphere virtual machines"
  default     = "datastore1"
}

variable "vm-network" {
  type        = string
  description = "Network used for the vSphere virtual machines"
  default     = "VM Network"
}

variable "cpu" {
  description = "Number of vCPU for the vSphere virtual machines"
}

variable "cores-per-socket" {
  description = "Number of cores per cpu for workers"
}

variable "ram" {
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
}

variable "disksize" {
  description = "Disk size, example 100 for 100 GB"
}

variable "vm-guest-id" {
  type        = string
  description = "The ID of virtual machines operating system"
}

variable "vm-template-name" {
  type        = string
  description = "The template to clone to create the VM"
}

variable "ssh_username" {
  type      = string
  sensitive = true
}

variable "public_key" {
  type        = string
  description = "Public key to be used to ssh into a machine"
}

#================================#
#       Fortinet Variables       #
#================================#
variable "fortigate_ip" {
  type = string
}

variable "fortigate_api_token" {
  type = string
}