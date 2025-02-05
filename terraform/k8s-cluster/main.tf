module "k8s-vpc" {
  source = "github.com/excircle/tf-aws-minio-vpc"

  application_name      = "k8s-vpc"
  az_count              = 2
  make_private          = false
  createdby_tag         = "Terraform"
  owner_tag             = "AlexanderKalaj"
  purpose_tag           = "k8s-vpc"
}


module "k8s-node" {
  source = "github.com/excircle/tf-cncf-k8s-node"

  application_name          = "k8s-node"
  system_user               = "ubuntu"
  hosts                     = 3                              # Number of nodes with MinIO installed
  vpc_id                    = module.k8s-vpc.vpc_id
  ebs_root_volume_size      = 10
  ebs_storage_volume_size   = 20
  make_private              = false
  ec2_instance_type         = "t2.medium"
  ec2_ami_image             = "ami-07a7eda24f3bc8430"        # ami-07a7eda24f3bc8430 | us-west-2 AMI | Ubuntu 22.04.4 LTS (Jammy Jellyfish) Packer Image
  az_count                  = 2                              # Number of AZs to use
  subnets                   = module.k8s-vpc.subnets
  num_disks                 = 0                              # Creates a number of disks
  sshkey                    = var.sshkey                     # Use env variables | export TF_VAR_sshkey=$(cat ~/.ssh/your-key-name.pub)
  ec2_key_name              = "quick-key"
  package_manager           = "apt"
  bastion_host              = false
  generate_disk_info        = true
}

module "minio-disks" {
  source = "github.com/excircle/tf-aws-minio-disks"

  minio_hosts = module.k8s-node.minio_host_info
  disk_names = module.k8s-node.disk-names
  ebs_storage_volume_size = module.k8s-node.ebs_storage_volume_size
}