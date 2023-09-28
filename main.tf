terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "jenkins_builds_health_score_incident" {
  source    = "./modules/jenkins_builds_health_score_incident"

  providers = {
    shoreline = shoreline
  }
}