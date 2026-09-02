resource "aws_key_pair" "terra_project" {
  key_name   = "terra-project-key"
  public_key = file("C:/Users/X/.ssh/id_ed25519.pub")
}

resource "aws_instance" "terra-project" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address  = true
  key_name                    = aws_key_pair.terra_project.key_name
  vpc_security_group_ids      = [aws_security_group.terra_project_sg.id]
  user_data                   = file("${path.module}/install-ngnix.sh")

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
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

