terraform {
  required_providers {
    porkbun = {
      source  = "cullenmcdermott/porkbun"
      version = "0.3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.90"
    }
  }

  backend "s3" {
    dynamodb_table = "slug_infra_opentofu_backend_table"
    bucket         = "slug-infra-opentofu-backend-bucket"
    key            = "slug/terraform.tfstate"
    region         = "us-east-2"
  }
}

locals {
  backend_bucket = "slug-infra-opentofu-backend-bucket"
  backend_table  = "slug_infra_opentofu_backend_table"
}

variable "porkbun_api_key" {
  type      = string
  sensitive = true
}

variable "porkbun_secret_key" {
  type      = string
  sensitive = true
}

provider "porkbun" {
  api_key    = var.porkbun_api_key
  secret_key = var.porkbun_secret_key
}

provider "aws" {
  region = "us-east-2"
}

# Backend bucket for OpenTofu

resource "aws_s3_bucket" "opentofu_backend_bucket" {
  bucket = local.backend_bucket
}

resource "aws_s3_bucket_public_access_block" "opentofu_backend_bucket_pub" {
  bucket                  = local.backend_bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "opentofu_backend_bucket_versioning" {
  bucket = local.backend_bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "opentofu_backend_state_lock_table" {
  name     = local.backend_table
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  read_capacity  = 5
  write_capacity = 5
}
