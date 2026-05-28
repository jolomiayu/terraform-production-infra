output "terraform_backend_bucket" {
  value = "jolomiayu-terraform-state"
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "website_url" {
  value = "http://${module.alb.alb_dns_name}"
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "db_name" {
  value = module.database.db_name
}
