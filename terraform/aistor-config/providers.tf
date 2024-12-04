terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.33.0"
    }
  }
  backend "s3" {}
}

provider "kubernetes" {
  config_path = "./config"
}