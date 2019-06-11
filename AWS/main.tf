provider "aws" {
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  version = "~> 2.14"
}

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "kafka" {
  ami = var.ami
  key_name = aws_key_pair.auth.id
  instance_type = var.instance_type
    tags = {
    Name = "Kafka Connector Demo"
  }
}
