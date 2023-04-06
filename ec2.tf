resource "aws_instance" "server-01" {
  ami           = var.amis["sa-east-1"]
  instance_type = "t2.micro"
  key_name      = "terraform-adm"
  tags = {
    Name = "server-01"
  }
  # vpc_security_group_ids = ["${aws_security_group.sg-ssh.id}", "${aws_security_group.sg-internet.id}"]
  user_data = <<-EOF
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

  # vpc_security_group_ids = ["${aws_security_group.sg-ssh.id}", "${aws_security_group.sg-internet.id}"]
  user_data = <<-EOF
              #!/bin/bash
              sudo su
              yum update -y
              yum install -y httpd
              sudo echo "Hello, server-02" > /var/www/html/index.html
              sudo service httpd start
              sudo chkconfig httpd on
              EOF
}