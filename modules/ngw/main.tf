resource "aws_eip" "main" {
  vpc = true
}
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = var.pub_subnet_id[0]

  tags = {
    Name = "ngw-${terraform.workspace}"
  }
  depends_on = [var.igw]
}