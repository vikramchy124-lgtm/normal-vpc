resource "aws_key_pair" "terra_project" {
  key_name   = "terra-project-key"
  public_key = file("C:/Users/X/.ssh/id_ed25519.pub")
}

resource "aws_instance" "terra-project" {
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.terra_project.key_name
  vpc_security_group_ids = [aws_security_group.terra_project_sg.id]

  tags = {
    Name = "terra-project"
  }
}

output "ec2_public_ip" {
  value = aws_instance.terra-project.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.terra-project.private_ip
}

output "ec2_public_dns" {
  value = aws_instance.terra-project.public_dns
}

resource "aws_security_group" "terra_project_sg" {
  name        = "terra-project-sg"
  description = "Security group for terra project"

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

