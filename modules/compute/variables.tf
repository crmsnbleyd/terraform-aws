variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "fargate_cpu" {
  type    = number
  default = 256
}

variable "fargate_memory" {
  type    = number
  default = 512
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "tags" {
  type = map(string)
}
