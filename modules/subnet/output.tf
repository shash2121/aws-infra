output "pub_subnet_id" {
  value = aws_subnet.public[*].id
}
output "subnet" {
  value = {}
  depends_on = [
    aws_subnet.private
  ]
}
output "priv_subnet_ids" {
  value = aws_subnet.private[*].id
}