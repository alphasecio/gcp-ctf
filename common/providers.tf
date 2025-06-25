terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.40"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}

provider "google" {
  region = var.region
  zone   = var.zone
}
