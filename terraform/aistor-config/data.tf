locals {
  pvs = flatten(
    [for h in var.hostnames : 
        [for i in range(1, var.disk_count+1) : "${h}-disk${i}"]
    ]
  )
}