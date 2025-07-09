# 1.) Create Default Storage Class
resource "kubernetes_manifest" "default_storage_class" {
  manifest = yamldecode(templatefile("${path.module}/manifests/default-storage-class.yaml", {
    storage_class_name             = var.storage_class_name
    is_default_storage_class       = var.is_default_storage_class
    sto_class_volume_binding_mode  = var.sto_class_volume_binding_mode
    sto_class_reclaim_policy       = var.sto_class_reclaim_policy
  }))
}

# 2.) Create Persistent Volume
resource "kubernetes_manifest" "persistent_volume" {
  for_each = local.pvs

  manifest = yamldecode(templatefile("${path.module}/manifests/persistent-volume.yaml", {
    aistor_pv_name                 = format("%s", "${each.key}")
    aistor_pv_size                 = var.aistor_pv_size
    aistor_data_dir                = format("/mnt/data%d", replace("${each.key}", "/k8s-node-.*-disk/", ""))
    hostname                       = format("%s", replace("${each.key}", "/-disk.*/", "")) 
    storage_class_name             = var.storage_class_name
  }))
}