terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
  backend "s3" {}
}

provider "kubernetes" {
  config_path = "./config"
}

provider "random" {}