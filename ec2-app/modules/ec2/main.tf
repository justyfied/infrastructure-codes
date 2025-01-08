resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow HTTP and SSH access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key_pair"
  public_key = var.ec2_public_key
}

resource "aws_launch_template" "ec2_launch_template" {
  name_prefix = "ec2-launch-template"
  image_id     = "ami-0c55b159cbfafe1f0"  # Replace with your own AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name

  security_group_names = [aws_security_group.ec2_sg.name]
}
