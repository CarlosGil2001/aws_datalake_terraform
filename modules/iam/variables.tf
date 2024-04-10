variable "bucket_arns" {
   description = "ARN de los buckets"
   type        = map(string)
 }

variable "database_arn" {
   description = "ARN de Data Catalog"
   type        =  string
 }
