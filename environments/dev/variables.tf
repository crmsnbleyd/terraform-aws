variable "environment" {
  type    = string
  default = "dev"
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "DemoApp"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "enable_nat_gateway" {
  type    = bool
  default = false # Save cost in dev
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
  type        = string
  description = "The image to deploy (provided by CI/CD)"
}
