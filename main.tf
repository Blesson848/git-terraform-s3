
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

