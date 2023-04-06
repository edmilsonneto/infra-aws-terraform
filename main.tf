provider "aws" {
  version = "~>2.7"
  region  = "sa-east-1"
}

resource "aws_lb_target_group" "target-group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id      = "vpc-06165b90e1a163c66"
}

resource "aws_lb" "load-balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-ssh.id}", "${aws_security_group.sg-internet.id}"]
  subnets            = ["subnet-04aaa83496bff9c3b"]
}

resource "aws_lb_target_group_attachment" "instance-attachment" {
  target_group_arn = "${aws_lb_target_group.target-group.arn}"
  target_id        = "${aws_instance.server-01.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance-attachment2" {
  target_group_arn = "${aws_lb_target_group.target-group.arn}"
  target_id        = "${aws_instance.server-02.id}"
  port             = 80
}