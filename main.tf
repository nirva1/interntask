provider "aws" {
  region = "us-west-2"
  access_key = "AKIAZKOZZMKPYVSWZ732"
  secret_key = "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"
}
// Instance having web server deployed using user_data
resource "aws_instance" "terrInstance" {
  ami                         = "ami-0ca285d4c2cda3300"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.serverSG.id]
  user_data                   = <<-EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Learning Terraform is Fun !!!">/var/www/html/index.html
EOF
  tags = {
    Name = "Web Server"
  }
}
// Security Group
resource "aws_security_group" "serverSG" {
  description = "Allow HTTP and HTTPS traffic"
  name        = "serverSG"
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}