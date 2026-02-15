# entry point for edge creation/upgrade
locals {
  is_windows = false
  temp_dir = var.linux_temp_dir
}

locals {
  config_data = jsondecode(file(var.config_file))
  platform = "ec2"
}

provider "aws" {
  region = local.config_data.aws.region
  access_key = local.config_data.aws.credentials.access_key
  secret_key = local.config_data.aws.credentials.secret_key
  assume_role {
    role_arn     = local.config_data.aws.credentials.role_arn
  }
}

# call the aws create module if the is operation is create
module "aws_create" {
  source = "./create"
  count = (var.operation == "create") ? 1 : 0
  config_data = local.config_data
  api_endpoints = var.api_endpoints
  platform = var.platform
  operation = var.operation
  temp_dir = local.temp_dir
} 

