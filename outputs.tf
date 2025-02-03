locals {
  protocol         = var.enable_https ? "https" : "http"
  vanity_subdomain = local.subdomain_name
  port             = var.enable_https ? 443 : local.service_port
  vanity_url       = "${local.protocol}://${local.vanity_subdomain}:${local.port}"
}

output "public_urls" {
  value = [
    {
      url = local.vanity_url
    }
  ]
}

output "readiness_probes" {
  value = [
    {
      initial_delay_seconds = 0
      period_seconds        = 1
      timeout_seconds       = 1
      success_threshold     = 1
      http_get = jsonencode({
        path = var.health_check_path
        port = local.container_port
      })
    }
  ]
}
