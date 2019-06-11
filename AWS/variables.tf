variable "region" {
  default = "us-west-2"
}

variable "shared_credentials_file" {
  default = "/c/Users/mharding/.aws/credentials"
}

variable "ami" {
  default = "ami-01ed306a12b7d1c96"  
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "terraform.pub"
}

variable "public_key_path" {
  default = "..\\..\\terraform.pub"
}
