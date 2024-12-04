variable "sshkey" {
  description = "SSH key to use for the EC2 instances"
  type        = string
}

variable "generate_disk_info" {
  description = "Generate disk_info.json file"
  type = bool
  default = false
}