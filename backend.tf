terraform {
  backend "s3" {
    bucket = "tfstate.blesson.shop"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

