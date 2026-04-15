module "networking" {
  source = "../../modules/networking"

  environment        = var.environment
  vpc_cidr           = "10.1.0.0/16" # Different CIDR to allow for potential VPC Peering
  enable_nat_gateway = var.enable_nat_gateway
  tags               = var.common_tags
}

module "load_balancer" {
  source = "../../modules/load_balancer"

  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  container_port    = var.container_port
  health_check_path = var.health_check_path
  tags              = var.common_tags
}

module "compute" {
  source = "../../modules/compute"

  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  target_group_arn   = module.load_balancer.target_group_arn
  alb_sg_id          = module.load_balancer.alb_sg_id
  
  fargate_cpu        = var.fargate_cpu
  fargate_memory     = var.fargate_memory
  container_image    = var.container_image
  container_port     = var.container_port
  
  tags               = var.common_tags
}
