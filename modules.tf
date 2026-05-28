module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id
}

module "alb" {
  source = "./modules/alb"

  alb_sg_id          = module.security.alb_sg_id
  public_subnet_id   = module.network.public_subnet_id
  public_subnet_2_id = module.network.public_subnet_2_id
  vpc_id             = module.network.vpc_id
}

module "autoscaling" {
  source = "./modules/autoscaling"

  instance_type      = var.instance_type
  web_sg_id          = module.security.web_sg_id
  public_subnet_id   = module.network.public_subnet_id
  public_subnet_2_id = module.network.public_subnet_2_id
  target_group_arn   = module.alb.target_group_arn

  ami_id   = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.terraform_key.key_name
}

module "database" {
  source = "./modules/database"

  vpc_id              = module.network.vpc_id
  private_subnet_id   = module.network.private_subnet_id
  private_subnet_2_id = module.network.private_subnet_2_id
  web_sg_id           = module.security.web_sg_id
}

