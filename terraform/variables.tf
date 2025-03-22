variable "PVE_URL" {
  type        = string
  sensitive   = false
  description = "Full URL to the PVE cluster. Specify using the TF_VAR_PVE_URL environment varialbe!"
}
variable "PVE_PASSWORD" {
  type        = string
  sensitive   = true
  description = "Proxmox Password. Specify using the TF_VAR_PVE_PASSWORD environment variable!"
}

variable "PVE_USERNAME" {
  type        = string
  sensitive   = true
  description = "Proxmox Cluster Username. Specify using TF_VAR_PVE_USERNAME environment variable!"
}

