output "common" {
  value = var.common
}

output "secret" {
  value     = var.secret
  sensitive = true
}