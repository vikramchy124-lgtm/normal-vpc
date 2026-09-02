

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_launch_template" "web" {
  name_prefix   = "terraform-asg-"
  image_id      = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = "t3.micro"

  security_group_names = []

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install nginx -y
    systemctl enable nginx
    systemctl start nginx

    echo "<h1>Hello this is Bikram from terraform </h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Terraform ASG Instance"


    }
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "terraform-web-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  vpc_zone_identifier = module.vpc.public_subnets

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.app_tg.arn
  ]

  health_check_type = "ELB"
}