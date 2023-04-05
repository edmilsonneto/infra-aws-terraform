resource "aws_instance" "server-01" {
  ami           = var.amis["sa-east-1"]
  instance_type = "t2.micro"
  key_name      = "terraform-adm"
  tags = {
    Name = "server-01"
  }
  vpc_security_group_ids = ["${aws_security_group.http.id}", "${aws_security_group.ssh.id}"]
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              cd /var/www
              sudo mkdirhtml
              sudo chmod +777 html
              sudo echo "Hello, server-01!" > index.html
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
  vpc_security_group_ids = ["${aws_security_group.http.id}", "${aws_security_group.ssh.id}"]
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              cd /var/www
              sudo mkdirhtml
              sudo chmod +777 html
              sudo echo "Hello, server-02!" > index.html
              sudo service httpd start
              sudo chkconfig httpd on
              EOF
}