terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = var.region
}
module "my_vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_tenancy = var.vpc_tenancy
}
module "my_subnet" {
  source = "./modules/subnet"
  id_vpc = module.my_vpc.vpc_id
  nat_gateway_id = module.my_ngw.ngw_id
  gateway_id = module.my_igw.igw_id
  ngw = module.my_ngw.ngw
  #subnet = module.my_subnet.subnet
  pub_subnet_id = module.my_subnet.pub_subnet_id
}
module "my_igw"{
  source = "./modules/igw"
  vpc_id = module.my_vpc.vpc_id
}
module "my_ngw" {
    source = "./modules/ngw"
    pub_subnet_id = module.my_subnet.pub_subnet_id
    igw = module.my_igw.igw
}
module "sg" {
  source = "./modules/sg"
  id_vpc = module.my_vpc.vpc_id
}
module "alb" {
  depends_on = [
    module.my_subnet
  ]
  source = "./modules/alb"
  alb_security_group = module.sg.sg_id
  alb_subnet_id = module.my_subnet.pub_subnet_id
}
module "secret" {
  source = "./modules/secrets"
}

module "eks" {
  depends_on = [
    module.sg, module.secret, module.my_subnet, module.compute, module.iam
  ]
    source = "./modules/eks"
    secgrp = module.sg.sg_id
    subnet_ids = module.my_subnet.priv_subnet_ids
}

module "compute" {
  depends_on = [
    module.secret
  ]
  source = "./modules/ec2"
  ec2 = {
    inst_type = "t3a.small"
    ami_id = "ami-0caf778a172362f1c"
    sg_pub_id = module.sg.sg_id
    pub_subnet_id = module.my_subnet.pub_subnet_id
    iam_instance_profile = module.iam.iam_instance_profile
  }
  app = {
    inst_type = "t3a.medium"
    ami_id = "ami-0caf778a172362f1c"
    sg_pub_id = module.sg.sg_id
    priv_subnet_ids = module.my_subnet.priv_subnet_ids
    iam_instance_profile = module.iam.iam_instance_profile
  }
}
module "iam" {
  source = "./modules/iam"
}