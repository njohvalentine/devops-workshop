provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "demo-server" {
  ami           = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"
  key_name      = "terraformkey"
  security_groups = ["demo-sg"]
  tags = {
    Name = "project_web-server"
  }

}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "demo-sg"
  }
  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

