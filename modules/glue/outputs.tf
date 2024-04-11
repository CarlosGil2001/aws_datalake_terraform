#-----------------------------------
# Output ARN AWS Glue Catalog
#-----------------------------------
output "database_arn" {
  description = "ARN Database Catalog"
  value = aws_glue_catalog_database.catalog_database.arn
}


