data "terraform_remote_state" "base_infra" {
  backend = "s3"

  config = {
    bucket  = "bnjns-terraform"
    key     = "base-infra.tfstate"
    region  = "eu-west-1"
    profile = "backstage"
  }
}
