locals {
  lambda_function__xosphere_organization_inventory_collector = "xosphere-instance-orchestrator-org-inv-collector"
  lambda_function__xosphere_organization_inventory_updates_submitter = "xosphere-instance-orchestrator-org-inv-upd-sub"
  endpoints_map__xosphere_cfn_prefix = "https://xosphere-io-public-cfn-templates.s3-us-west-2.amazonaws.com"
}

resource "aws_iam_role" "xosphere_organization_inventory_collector_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Sid": "AllowAssumeFromXosphereManagementAccount",
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "AWS": "${join("", [ "arn:aws:iam::", var.xosphere_mgmt_account_id, ":root" ])}"
    }
  }
}
EOF
  managed_policy_arns = [ ]
  path = "/"
  name = "${local.lambda_function__xosphere_organization_inventory_collector}-assume-role"
}

resource "aws_iam_role_policy" "xosphere_organization_inventory_collector_role_policy" {
  name = "${local.lambda_function__xosphere_organization_inventory_collector}-lambda-policy"
  role = aws_iam_role.xosphere_organization_inventory_collector_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOperationsWithoutResourceRestrictions",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeRegions",
        "ec2:DescribeInstances"
	    ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "xosphere_organization_inventory_realtime_updates_submission_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Sid": "AllowAssumeFromEventBridge",
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "events.amazonaws.com"
    }
  }
}
EOF
  managed_policy_arns = [ ]
  path = "/"
  name = "${local.lambda_function__xosphere_organization_inventory_updates_submitter}-assume-role"
}

resource "aws_iam_role_policy" "xosphere_organization_inventory_realtime_updates_submission_role_policy" {
  name = "${local.lambda_function__xosphere_organization_inventory_updates_submitter}-policy"
  role = aws_iam_role.xosphere_organization_inventory_realtime_updates_submission_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowRelayEvents",
      "Effect": "Allow",
      "Action": [
        "events:PutEvents"
	    ],
      "Resource": "${join(":", [ "arn:aws:events", var.xosphere_mgmt_account_region, var.xosphere_mgmt_account_id, "event-bus/xosphere-instance-orchestrator-org-inv-realtime-updates-bus" ] )}"
    }
  ]
}
EOF
}


output "xosphere_organization_inventory_realtime_updates_submission_role_arn" {
  value = aws_iam_role.xosphere_organization_inventory_realtime_updates_submission_role.arn
}