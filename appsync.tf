locals {
    datasource_prefix_dashboard = "${local.deploy_id}_dashboard"
    resolvers_path = "${path.module}/appsync/resolvers"
    resolvers = {for file in fileset("appsync/resolvers", "**/datasource") :
        split("/", file)[1] => split("/", file)[0]
    }
    datasources_template_vars = {
        urls_datasource = aws_appsync_datasource.dynamodb_collatz_table.name
    }
}

resource "aws_appsync_graphql_api" "app" {
  authentication_type = "API_KEY"
  name                = "${local.deploy_id}_app"


  schema = file("${path.module}/appsync/schema.graphql")

  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.appsync.arn
    field_log_level          = "ALL"
  }
}

resource "aws_appsync_api_key" "api_key" {
  api_id  = aws_appsync_graphql_api.app.id
  expires     = timeadd(timestamp(), "8700h")
}

resource "aws_appsync_datasource" "dynamodb_collatz_table" {
  api_id           = aws_appsync_graphql_api.app.id
  name             = "${var.deploy_id}_${var.environment}dynamodb_collatz_table"
  service_role_arn = aws_iam_role.appsync.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.collatz_table.name
  }
}

resource "aws_appsync_resolver" "resolvers" {
  for_each = local.resolvers

  api_id      = aws_appsync_graphql_api.app.id
  type        = each.value
  field       = each.key
  data_source = templatefile("${local.resolvers_path}/${each.value}/${each.key}/datasource", local.datasources_template_vars)

  request_template = file("${local.resolvers_path}/${each.value}/${each.key}/request")

  response_template = (
      fileexists("${local.resolvers_path}/${each.value}/${each.key}/response") ? (
        file("${local.resolvers_path}/${each.value}/${each.key}/response")
      ) : (
        file("${local.resolvers_path}/default_response")
      )
  )
}
