variable "env" {
    description = "This is the environment for my infra"
    type = string
  
}

variable "bucket_name"{
    description = "This is the bucket name for my infra"
    type = string
}

variable "instance_count" {
    description = "This is the no. of the ec2 instance"
    type = number
}

variable "instance_type" {
    description = "This is the instance type for my Ec2 infra"
    type = string
}

variable "ec2_ami_id"{
    description = "This is the instance ami for my Ec2 infra "
    type = string
}

variable "hash_key" {
    description = "this is the hash key for my Ec2 infra"
    type = string
}

