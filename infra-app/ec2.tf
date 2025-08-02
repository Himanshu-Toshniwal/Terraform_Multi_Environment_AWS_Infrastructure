# key pair (login)
resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-infra-app-key"           #key-name
  public_key = file("terra-key-ec2.pub") # ssh-keyegen use key:terra-key-ec2 

   tags = {
    Environment = var.env
   }
}
#VPC & Security Group

resource "aws_default_vpc" "default" {

}
resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-infra-app-sg" # security group name
  description = "this will addd a TF generated Security group"
  vpc_id      = aws_default_vpc.default.id # interpolation : it is the way in which you can  inherit or extract the values from terraform block

  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask app"
  }

  # outbound rules

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # semantically equivalent to all ports(all access)
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }

  tags = {
    Name = "${var.env}-infra-app-sg"
  }
}

# ec2 instance

resource "aws_instance" "my_instance" {
  # count = 2 # meta argument
  count = var.instance_count

  depends_on      = [aws_security_group.my_security_group, aws_key_pair.my_key]


  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  # instance_type   = var.ec2_instance_type
  instance_type = var.instance_type
  ami           = var.ec2_ami_id# ubuntu

#   user_data     = file("install_nginx.sh")

  root_block_device {
    # volume_size = var.ec2_root_storage_size #storage
    volume_size = var.env == "prd" ? 20 : 10
    volume_type = "gp3"
  }
  tags = {
    # Name = "Terraform-automate" # Name
    Name = "${var.env}-infra-app-instance"
    Environment = var.env
  }
}








