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
  ebs_block_device {
    device_name = "/dev/sda1"
    delete_on_termination = true
  }

  connection {
      type     = "ssh"
      host     = self.public_ip
      user     = "centos"
      private_key = file(var.private_key_path)
  }

  provisioner "file" {
  source      = "../common/snowflake-kafka-connector-0.3.jar"
  destination = "snowflake-kafka-connector-0.3.jar"
  }

  provisioner "file" {
  source      = "files/bootstrap.sh"
  destination = "bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x bootstrap.sh",
      "./bootstrap.sh > bootstrap.log",
    ]
  }

}


output "public_ip" {
  value = aws_instance.kafka.public_ip
}