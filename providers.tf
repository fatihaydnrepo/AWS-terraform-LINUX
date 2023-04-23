terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region                   = "us-west-2"
  shared_config_files      = ["~/.aws/conf"]
  shared_credentials_files = ["~/.aws/creds"]
  access_key               = "AKIARZ5UNZREH6TVKSHR"
  secret_key               = "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"
}

