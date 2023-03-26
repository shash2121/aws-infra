
variable "internal_alb" {
    default = false
}

variable "alb_security_group" {}
variable "alb_subnet_id" {}
variable "tags" {
  type        = map(string)
  default     = {}
}