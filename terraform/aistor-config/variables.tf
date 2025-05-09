variable "storage_class_name" {
  description = "Name of the storage class"
  type        = string
  default     = "aistor-storage"
}

variable "is_default_storage_class" {
  description = "Option to set default storage class"
  type        = bool
  default     = true
}

variable "sto_class_volume_binding_mode" {
  description = "Volume binding mode"
  type        = string
  default     = "WaitForFirstConsumer"
}

variable "sto_class_reclaim_policy" {
  description = "Reclaim policy"
  type        = string
  default     = "Delete"
}

variable "aistor_pv_name" {
  description = "Name of the volume"
  type        = string
  default     = "aistor-pv"
}

variable "aistor_pv_size" {
  description = "Size of the volume"
  type        = string
}

variable "disk_count" {
  description = "Number of disks"
  type        = number
}

variable "hostnames" {
  description = "Hostnames"
  type        = list(string)
}