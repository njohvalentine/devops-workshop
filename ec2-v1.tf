provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "demo-server" {
  ami           = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"
  key_name      = "terraformkey"
  vpc_security_group_ids = aws_security_group" "demo-sg
  subnet_id = aws_subnet.demo_pub-subnet.id
  tags = {
    Name = "project_web-server"
  }

}

resource "aws_vpc" "demo-vpc" {
    cidr_block = "10.5.0.0/16"
    tags = {
      Name = "demo-project-vpc"
    }  
}

resource "aws_subnet" "demo_pub-subnet" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = "10.5.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "demo-project-public-subnet"
    }
}

resource "aws_subnet" "demo_pub-subnet2" {
    vpc_id = "aws_vpc.demo-vpc.id"
    cidr_block = "10.5.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "demo-project-public-subnet2"
    }
}

resource "aws_internet_gateway" "demo-IGW" {
    vpc_id = "aws_vpc.demo-vpc.id"
    tags = {
      Name= "demo-projetc-IGW"
    }
}

resource "aws_route_table" "demo-public-RT" {
    vpc_id = "aws_vpc.demo-vpc.id"
    route = {
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.demo-IGW.id
    }
    tags = {
      Name= "demo-project-public-RT"
    }
}

resource "aws_route_table_association" "rt-asso" {
    subnet_id = aws_subnet.demo_pub-subnet.id
    route_table_id = aws_route_table.demo-public-RT.id
}

resource "aws_route_table_association" "rt-asso" {
    subnet_id = aws_subnet.demo_pub-subnet2.id
    route_table_id = aws_route_table.demo-public-RT.id
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id = aws_vpc.demo-vpc.id

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



