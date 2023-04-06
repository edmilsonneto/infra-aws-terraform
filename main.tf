provider "aws" {
  version = "~>2.7"
  region  = "sa-east-1"
}

resource "aws_instance" "server-01" {
  ami           = var.amis["sa-east-1"]
  instance_type = "t2.micro"
  key_name      = "terraform-adm"
  tags = {
    Name = "server-01"
  }
  vpc_security_group_ids = ["${aws_security_group.sg-ssh.id}", "${aws_security_group.sg-internet.id}"]
  user_data              = <<-EOF
              #!/bin/bash
              sudo su
              yum update -y
              yum install -y httpd
              sudo echo "Hello, server-01" > /var/www/html/index.html
              sudo service httpd start
              sudo chkconfig httpd on
              EOF
}

resource "aws_instance" "server-02" {
  ami           = var.amis["sa-east-1"]
  instance_type = "t2.micro"
  key_name      = "terraform-adm"
  tags = {
    Name = "server-02"
  }
  vpc_security_group_ids = ["${aws_security_group.sg-ssh.id}", "${aws_security_group.sg-internet.id}"]
  user_data              = <<-EOF
              #!/bin/bash
              sudo su
              yum update -y
              yum install -y httpd
              sudo echo "Hello, server-02" > /var/www/html/index.html
              sudo service httpd start
              sudo chkconfig httpd on
              EOF
}

resource "aws_security_group" "sg-ssh" {
  name        = "ssh"
  description = "ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh"
  }
}

resource "aws_security_group" "sg-internet" {
  name        = "internet"
  description = "internet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "internet"
  }
}

resource "aws_lb_target_group" "target-group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id = "vpc-06165b90e1a163c66"
}

resource "aws_lb" "load-balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-ssh.id}", "${aws_security_group.sg-internet.id}"]
  subnets            = ["subnet-04aaa83496bff9c3b", "subnet-0a206f3457bc8fe13", "subnet-09e98ee560fb31cd1"]
}

resource "aws_lb_target_group_attachment" "server-01-instance-attachment" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.server-01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "server-02-instance-attachment2" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.server-02.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target-group.arn
    type             = "forward"
  }
}
