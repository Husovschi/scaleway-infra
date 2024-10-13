terraform {
  required_version = ">= 1.9.7"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.46.0"
    }
  }
}

resource "scaleway_object_bucket" "vault_bucket" {
  name   = "husovschi-vault"
  region = "pl-waw"
}

resource "scaleway_object_bucket_acl" "vault_acl" {
  bucket = scaleway_object_bucket.vault_bucket.name
  acl    = "private"
  region = "pl-waw"
}
