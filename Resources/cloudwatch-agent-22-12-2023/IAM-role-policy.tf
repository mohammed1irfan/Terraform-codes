locals {
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AmazonCloudWatchRUMFullAccess"
  ]
}
