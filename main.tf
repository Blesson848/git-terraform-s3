
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


