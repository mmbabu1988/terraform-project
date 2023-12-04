terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIASNXG6SDJAUAKRY3R"
  secret_key = "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"
}
