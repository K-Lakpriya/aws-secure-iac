module "vpc" {
  source = "./modules/vpc"
  environment = var.environment
  product_name = var.product_name
}

module "iam" {
  source = "./modules/iam"
  environment = var.environment
  product_name = var.product_name
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id             = module.vpc.vpc_id
  private_subnet_id  = module.vpc.private_subnet_ids[0]
  instance_profile_name = module.iam.instance_profile_name
  ami_id = var.ami_id
  instance_type = var.instance_type
  volume_size = var.volume_size
  environment = var.environment
  product_name = var.product_name
}

module "cloudtrail" {
  source = "./modules/cloudtrail"
  environment = var.environment
  product_name = var.product_name
}

module "config" {
  source = "./modules/config"
  environment = var.environment
  product_name = var.product_name
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  environment = var.environment
  product_name = var.product_name
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
  environment = var.environment
  product_name = var.product_name
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  environment = var.environment
  product_name = var.product_name
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  target_instance_id = module.ec2.instance_id
  
}