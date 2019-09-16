variable "region" {
  default = "us-west-2"
}

variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "ami" {
  default = "ami-01ed306a12b7d1c96"  
}

variable "instance_type" {
  default = "m5a.xlarge"
}

 variable "key_name" {
   default = "ec2-keys"
}

// Set the path to the location of your public key
variable "public_key_path" {
  default = "~/bin/ssh-keys/snowflake-mbp.pub"
}

variable "private_key_path" {
  default = "~/bin/ssh-keys/snowflake-mbp.pem"
}
