resource "aws_dynamodb_table" "my_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST" # 필요에 따라 변경할 수 있습니다
  hash_key     = var.hash_key

  dynamic "attribute" {
    for_each = var.table_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.table_attributes
    content {
      name = "GSI_${global_secondary_index.value.name}"
      hash_key = global_secondary_index.value.name
      projection_type = "ALL"
    }
  }

  tags = {
    NAME        = var.dynamodb_table_name
    Environment = "Dev"
  }
}

output "table_id" {
  value = aws_dynamodb_table.my_table.id
}