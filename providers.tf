terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.44.0"
    }
  }
  required_version = "~>1.7.0"   # utilizar un rango de versiones
}

provider "aws" {
    region = "us-east-2"
    default_tags {
      tags = var.tags  # tomar los tags para todos los servicios
    }
}