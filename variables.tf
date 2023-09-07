# Xosphere Instance Orchestration Org inventory collector
variable "xosphere_mgmt_account_id" {
  description = "AWS Account IDs of the Xosphere management account"
}

variable "xosphere_mgmt_account_region" {
  description = "AWS Region where the Xosphere management account components are installed"
}

variable "deployment_regions" {
  type = list
  description = "AWS Regions where the stackset is deployed to"
  default = [ "ap-northeast-1", "ap-northeast-2", "ap-northeast-3", "ap-south-1", "ap-southeast-1", "ap-southeast-2", "ca-central-1", "eu-central-1", "eu-north-1", "eu-west-1", "eu-west-2", "eu-west-3", "sa-east-1", "us-east-1", "us-east-2", "us-west-1", "us-west-2" ]
}

variable "xosphere_version" {
  description = "The version of this CloudFormation template"
  default = "0.0.0"
}