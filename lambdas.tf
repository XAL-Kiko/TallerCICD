################## Lambda Trigger Glue job ########################

module "trigger_collatz" {
  source = "git::ssh://git@gitlab.xalcloud.com:13579/Terraform/ResourceModules/lambda.git"
  


  filename      = data.archive_file.lambdas_zip["collatz"].output_path 
  function_name = "${local.deploy_id}-collatz-lambda"
  handler       = "main.handler"
  role_arn      = aws_iam_role.trigger_collatz.arn
  runtime       = "python3.8"
  layers        = [aws_lambda_layer_version.python_layer.arn]
  memory_size   = 2048 
  timeout       = 60 

  s3_trigger            = true
  s3_trigger_bucket_arn = module.zones.buckets["input"].arn

  env_variables = {
    CONFIG_TABLE = aws_dynamodb_table.collatz_table.name
  }

  tags = local.common_tags
}


# Trigger del bucket input para cuando pongan el fichero haga la lambda trigger_collatz
resource "aws_s3_bucket_notification" "trigger_collatz" {
  bucket = module.zones.buckets["input"].id

  lambda_function {
    lambda_function_arn = module.trigger_collatz.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# Definición de la policy de trigger_collatz
data "aws_iam_policy_document" "trigger_collatz" {
  statement {
    actions = [
      "dynamodb:*",
    ]
    resources = [
      aws_dynamodb_table.collatz_table.arn
    ]
  }

  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      module.zones.buckets["input"].arn,
      "${module.zones.buckets["input"].arn}/*"
    ]
  }

}

# Policy de trigger_collatz
resource "aws_iam_policy" "trigger_collatz" {
  name   = "${local.deploy_id}_trigger_collatz"
  policy = data.aws_iam_policy_document.trigger_collatz.json

  tags = local.common_tags
}

# Rol de la lambda
resource "aws_iam_role" "trigger_collatz" {
  name               = "${local.deploy_id}-collatz"
  assume_role_policy = data.aws_iam_policy_document.assume_role["lambda"].json

  tags = local.common_tags
}

#Añadimos la politica al rol
resource "aws_iam_role_policy_attachment" "trigger_collatz" {
  role       = aws_iam_role.trigger_collatz.name
  policy_arn = aws_iam_policy.trigger_collatz.arn
}

#python layer
resource "aws_lambda_layer_version" "python_layer" {
  filename   = "python_layer/layer.zip"
  layer_name = "python_layer"

  compatible_runtimes = ["python3.8"]

  source_code_hash = filebase64sha256("python_layer/layer.zip")
}

resource "aws_iam_role_policy_attachment" "trigger_glue_lambda_basic" {
  role       = aws_iam_role.trigger_collatz.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
