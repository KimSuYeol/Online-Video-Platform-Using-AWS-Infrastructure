variable "dynamodb_table_name" {
  description = "DynamoDB table_name"
  type        = string
}

variable "hash_key" {
  description = "DynamoDB Hash Key"
  type        = string
}

variable "table_attributes" {
  description = "List of attributes for the DynamoDB table"
  type = list(
    object({
      name = string
      type = string
    })
  )
  default = []
}