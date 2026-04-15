variable "environment" {
  type    = string
  default = "prd"
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "DemoApp"
    Environment = "prd"
    ManagedBy   = "Terraform"
    Owner       = "Demo-Team"
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
  default = true # Production needs NAT for private subnet egress (updates/patches)
}

variable "fargate_cpu" {
  type    = number
  default = 512 # Doubled from Dev
}

variable "fargate_memory" {
  type    = number
  default = 1024 # Doubled from Dev
}

variable "container_image" {
  type        = string
  description = "The image to deploy (provided by CI/CD)"
}
