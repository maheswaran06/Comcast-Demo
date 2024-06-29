###S3 VARIABLES###

variable "tags"{
    type = map(string)
    description = "The tags for the bucket"
}

variable "bucket_name"{
    type = string
    description = "The name for the bucket"
}