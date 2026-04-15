variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
}
