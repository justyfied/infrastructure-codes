module "secure_vpc" {
   source     = "./modules/vpc"
   vpc_cidr   = "10.0.0.0/16"
   name_prefix = "prod"
   availability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c"]
   public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
   private_subnet_cidrs   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

provider "aws" {
   region = "us-east-1"
}
