# 1.) Create Namespace
resource "kubernetes_namespace" "aistor_staging" {
  metadata {
    labels = {
      mylabel = "aistor-staging"
    }

    name = "aistor-staging"
  }
}

# 2.) Create Default Storage Class
resource "kubernetes_manifest" "default_storage_class" {
  manifest = yamldecode(templatefile("${path.module}/manifests/default-storage-class.yaml", {
    storage_class_name             = var.storage_class_name
    is_default_storage_class       = var.is_default_storage_class
    sto_class_volume_binding_mode  = var.sto_class_volume_binding_mode
    sto_class_reclaim_policy       = var.sto_class_reclaim_policy
  }))
}

# 3.) Create Persistent Volume
resource "kubernetes_manifest" "persistent_volume" {
  count = var.disk_count

  manifest = yamldecode(templatefile("${path.module}/manifests/persistent-volume.yaml", {
    aistor_pv_name  = format("%s-%d", var.aistor_pv_name, count.index+1)
    aistor_pv_size  = var.aistor_pv_size
    aistor_data_dir = format("/mnt/data%d", count.index+1)
    hostnames       = var.hostnames
  }))
}