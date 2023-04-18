locals {
  buckets = {
    "input" : {},
    "app" : {}
  }
}

# Creation of buckets
module "zones" {
  source = "git::ssh://git@gitlab.xalcloud.com:13579/Terraform/ResourceModules/buckets.git"

  bucket_prefix  = local.deploy_id
  buckets_config = local.buckets

  tags = local.common_tags
}