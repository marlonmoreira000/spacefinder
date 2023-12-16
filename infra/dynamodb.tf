resource "aws_dynamodb_table" "table_spacefinder" {
  name           = "Spacefinder"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "age"
    type = "N"
  }

  global_secondary_index {
    name            = "name_index"
    hash_key        = "name"
    projection_type = "ALL"
    read_capacity   = 2
    write_capacity  = 2
  }

  global_secondary_index {
    name            = "age_index"
    hash_key        = "age"
    projection_type = "ALL"
    read_capacity   = 2
    write_capacity  = 2
  }
}