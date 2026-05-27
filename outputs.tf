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

output "deployment_overrides" {
  description = <<EOF
Deployment configuration that the attached app module applies to coordinate rollouts with this load balancer (zero-downtime NEG rollouts).
Emitted as a list (consistent with other capability outputs) holding a single override object.
When `deprogram_secs = 0`, the list is empty (all-or-nothing opt-out) and the app falls back to Kubernetes defaults.
EOF
  value = var.deprogram_secs > 0 ? [
    {
      pre_stop_seconds                 = var.deprogram_secs
      termination_grace_period_seconds = var.deprogram_secs + var.app_drain_secs
    }
  ] : []
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
