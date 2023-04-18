resource "aws_iam_role" "appsync" {
  name               = "${local.deploy_id}-appsync_logging"

  assume_role_policy = data.aws_iam_policy_document.assume_role["appsync"].json
}

data "aws_iam_policy_document" "appsync_dynamodb_policy" {
  statement {
    actions = [
      "dynamodb:*",
    ]
    resources = [
      aws_dynamodb_table.collatz_table.arn,  
    ]
  }
}

resource "aws_iam_role_policy_attachment" "appsync-logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppSyncPushToCloudWatchLogs"
  role       = aws_iam_role.appsync.name
}

resource "aws_iam_role_policy_attachment" "appsync-dynamodb" {
  policy_arn = aws_iam_policy.appsync_dynamodb_policy.arn
  role       = aws_iam_role.appsync.name
}

resource "aws_iam_policy" "appsync_dynamodb_policy" {
  name   = "${local.deploy_id}-appsync_dynamodb_policy"
  path   = "/${local.deploy_id}/"
  policy = data.aws_iam_policy_document.appsync_dynamodb_policy.json
}