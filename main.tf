terraform {
  required_version = ">= 1.9.7"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.46.0"
    }
  }

  backend "s3" {
    bucket                      = "tf-state-husovschi"
    key                         = "scaleway-infra/terraform.tfstate"
    endpoints                   = { s3 = "https://s3.pl-waw.scw.cloud" }
    region                      = "pl-waw"
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}

provider "scaleway" {
  zone   = "pl-waw-1"
  region = "pl-waw"
}

module "vault" {
  source = "./modules/vault"
}
