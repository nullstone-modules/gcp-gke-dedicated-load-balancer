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
      period_seconds        = var.health_check_interval
      timeout_seconds       = var.health_check_timeout
      success_threshold     = var.health_check_healthy_threshold
      failure_threshold     = var.health_check_unhealthy_threshold
      http_get = jsonencode({
        path = var.health_check_path
        port = local.container_port
      })
    }
  ]
}
