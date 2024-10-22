terraform {
  /*
  cloud {
    organization = "mountains"
    workspaces {
      name = "Mountains-Dev"
    }
  }
  */
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66.1"
    }
  }
  required_version = ">= 1.0"
}
