terraform {
  cloud {
    organization = "ACME_CLOUD_INFRA"
    workspaces {
      name = "hashidog"
    }
  }
}