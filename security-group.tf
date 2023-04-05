resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "ssh"
  }
}

resource "aws_security_group" "http" {
  name        = "http"
  description = "http"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "http"
  }
}