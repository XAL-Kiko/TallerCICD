# Creation of urls dynamodb table
resource "aws_dynamodb_table" "collatz_table" {
  name         = "${local.deploy_id}_collatz"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "filename"

  attribute {
    name = "filename"
    type = "S"
  }

}