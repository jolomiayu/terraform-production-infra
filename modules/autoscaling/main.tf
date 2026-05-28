resource "aws_launch_template" "web_lt" {

  name_prefix   = "terraform-web-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    var.web_sg_id
  ]

  user_data = base64encode(<<-EOF
#!/bin/bash

apt update -y

apt install -y docker.io git curl

systemctl start docker
systemctl enable docker

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

cd /home/ubuntu

git clone https://github.com/jolomiayu/terraform-production-infra.git

cd terraform-production-infra/app

docker-compose up -d

EOF
  )

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "terraform-asg-web"
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {

  name             = "terraform-web-asg"
  desired_capacity = 2
  min_size         = 2
  max_size         = 2

  vpc_zone_identifier = [
    var.public_subnet_id,
    var.public_subnet_2_id
  ]

  target_group_arns = [
    var.target_group_arn
  ]

  launch_template {

    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  health_check_type = "ELB"

  tag {

    key                 = "Name"
    value               = "terraform-asg-web"
    propagate_at_launch = true
  }
}
