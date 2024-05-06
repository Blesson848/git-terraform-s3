
#--------------------------------------------------
# key_pair
#--------------------------------------------------

resource "aws_key_pair" "key_pair" {

  key_name   = "${var.project_name}-${var.project_env}-key"
  public_key = file("blez.pub")

  tags = {

    Name = "${var.project_name}-${var.project_env}-key"
  }
}




#--------------------------------------------------
# SG group for Backend
#--------------------------------------------------

resource "aws_security_group" "backend_access" {
  name_prefix = "${var.project_name}-${var.project_env}-backend-"
  description = "Allow TLS inbound traffic for backend"

  tags = {
    Name = "${var.project_name}-${var.project_env}-backend"

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_security_group_rule" "backend_ports" {

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_access.id
}

resource "aws_security_group_rule" "backend_ssh_access" {

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_access.id
}


resource "aws_security_group_rule" "backend_monitoring_access" {

  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_access.id
}



#--------------------------------------------------
# Backend server
#--------------------------------------------------

resource "aws_instance" "backend" {

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [aws_security_group.backend_access.id]
  user_data              = file("user.sh")

  tags = {

    Name = "${var.project_name}-${var.project_env}-backend"
  }

  lifecycle {
    create_before_destroy = true
  }
}


#--------------------------------------------------
# EIP
#--------------------------------------------------

resource "aws_eip" "backend" {
  instance = aws_instance.backend.id
  domain   = "vpc"
}

resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "${var.public_hostname}.${var.domain}"
  type    = "A"
  ttl     = 30
  records = [aws_eip.backend.public_ip]
}

