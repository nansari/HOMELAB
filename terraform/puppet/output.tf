output "all_buildhosts" {
  value       = var.buildhosts
  sensitive   = false
  description = "Details of hosts build by terraform"
  depends_on  = []
}
