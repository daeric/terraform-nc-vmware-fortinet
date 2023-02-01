#===========================#
# VMware vCenter connection #
#===========================#

#variable "vsphere_user" {
#  type        = string
#  description = "VMware vSphere user name"
#  sensitive   = true
#}

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

#================================#
# VMware vSphere virtual machine #
#================================#

variable "hostname" {
  type        = string
  description = "The name of the vSphere virtual machines and the hostname of the machine"
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

variable "ssh_username" {
  type      = string
  sensitive = true
}

variable "public_key" {
  type        = string
  description = "Public key to be used to ssh into a machine"
  sensitive   = true
}

#================================#
#       Fortinet Variables       #
#================================#

variable "fortigate_ip" {
  type        = string
  sensitive   = true
}

variable "fortigate_api_token" {
  type        = string
  sensitive   = true
}
