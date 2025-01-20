terraform {
  backend "s3" {
    bucket               = "wireapps-tf-state"
    workspace_key_prefix = "prod"
    key                  = "terraform.tfstate"
    region               = "ap-south-1"
  }
}
