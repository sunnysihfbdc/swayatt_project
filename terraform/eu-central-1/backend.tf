
##################################################################################
# REMOTE TERRAFORM STATE
##################################################################################

# Remote state file
terraform {
  backend "s3" {
    bucket         = "sunny-tf-state-bucket"
    key            = "eu-central-1.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}