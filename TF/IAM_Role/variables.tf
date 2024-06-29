### IAM ROLE VARIABLES ###

variable "name" {
    type = string
    description = "The IAM rolename"
}


variable "assume_role_policy" {
    type = string
    description = "The policy for the IAM role"
}