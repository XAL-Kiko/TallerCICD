# AWS provider and region
data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {}
}

locals {
  baseline_version = "v0.0.2"
  environment      = "${var.environment}"
  lambda_folders   = toset(distinct([for file in fileset("${path.module}/lambdas", "**/*") : dirname(file) if length(regexall(".*.zip", file)) == 0]))
  region           = "${var.region}"
  deploy_id        = "${var.deploy_id}-${var.environment}"
  common_tags = {
    project                   = "${var.deploy_id}-${var.environment}"
    stack_env                 = "${var.environment}"
    security_data_sensitivity = "protected"
    stack                     = "${var.deploy_id}-${var.environment}"
    stack_version             = "0.1.0"
    stack_lifecycle           = "perm"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "assume_role" {
  for_each = toset(["lambda", "s3", "dynamodb", "cloudfront", "appsync"])

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["${each.key}.amazonaws.com"]
    }
  }
}

data "archive_file" "lambdas_zip" {
  for_each = local.lambda_folders

  type             = "zip"
  output_file_mode = "0666"
  output_path      = "${path.module}/lambdas/${each.key}.zip"

  dynamic "source" {
    for_each = fileset("${path.module}/lambdas/${each.key}", "*")
    content {
      content  = file("${path.module}/lambdas/${each.key}/${source.key}")
      filename = source.key
    }
  }
}
