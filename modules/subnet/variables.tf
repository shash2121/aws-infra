variable "id_vpc" {
}
variable "cidr" {
  default = "10.0.0.0/16"
}
variable "tags" {
  type        = map(string)
  default     = {}
}

variable "nat_gateway_id" {
}
variable "gateway_id" {
}
variable "ngw" {
}
variable "pub_subnet_id" {
}