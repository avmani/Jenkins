module "efs_module" {
  source     = "../modules/efs"
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
}