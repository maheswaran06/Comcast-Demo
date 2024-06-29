### IAM ROLE VARIABLES ###

variable "rolename"{
    type = map(string)
    description = "The filename of the Lambda function"
}

### LAMBDA VARIABLES ###

variable "filename"{
    type = map(string)
    description = "The filename of the Lambda function"
}

variable "function_name"{
    type = map(string)
    description = "The function name of the Lambda function"
}

variable "handler"{
    type = map(string)
    description = "The function name of the Lambda function"
}

variable "runtime"{
    type = map(string)
    description = "The function name of the Lambda function"
}