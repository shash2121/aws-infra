variable "region" {
}
variable "vpc_cidr" {
}
variable "vpc_tenancy" {
}
variable "tags" {
  type        = map(string)
  default     = {}
}