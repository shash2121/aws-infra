resource "aws_security_group" "main" {
  vpc_id      = var.id_vpc
  
  tags = {
    Name = "${terraform.workspace}-sg"
  }
}
resource "aws_security_group_rule" "public_rules"{
  
  for_each          = var.sg_ingress
  type = "ingress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_block]
  description       = each.value.description
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "public_egress" {
  type              = "egress"
  to_port           = 0
  protocol          = -1
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}