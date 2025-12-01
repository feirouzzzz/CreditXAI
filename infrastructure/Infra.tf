########################################
# Provider
########################################
provider "aws" {
  region = "us-east-1"
}

########################################
# Use default VPC & subnets
########################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

########################################
# Create a new SSH key pair
########################################
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-generated-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  filename = "terraform-key.pem"
  content  = tls_private_key.ec2_key.private_key_pem

  file_permission = "0400"
}

########################################
# Security Group (allow SSH & HTTP)
########################################
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Spring"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# EC2 Instance
########################################
resource "aws_instance" "my_ec2" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu 22.04 (us-east-1)
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.default.ids[0]

  key_name = aws_key_pair.generated_key.key_name

  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "MyTerraformEC2"
  }
}

########################################
# Output public IP + SSH command
########################################
output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "ssh_command" {
  value = "ssh -i terraform-key.pem ubuntu@${aws_instance.my_ec2.public_ip}"
}
