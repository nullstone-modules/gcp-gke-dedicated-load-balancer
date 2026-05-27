resource "kubernetes_manifest" "health-check-policy" {
  lifecycle {
    precondition {
      # The health-check detection window must cover the LB deprogramming window so
      # the endpoint stays in rotation (and keeps serving, alongside the preStop
      # sleep) until the LB has finished deprogramming it during a rollout.
      condition     = var.health_check_unhealthy_threshold * var.health_check_interval >= var.deprogram_secs
      error_message = "HealthCheckPolicy detection window (health_check_unhealthy_threshold * health_check_interval = ${var.health_check_unhealthy_threshold * var.health_check_interval}s) must be >= var.deprogram_secs (${var.deprogram_secs}s)."
    }
  }

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "HealthCheckPolicy"

    metadata = {
      name      = local.resource_name
      namespace = local.kubernetes_namespace
      labels    = local.labels
    }

    spec = {
      default = {
        checkIntervalSec   = var.health_check_interval
        timeoutSec         = var.health_check_timeout
        healthyThreshold   = var.health_check_healthy_threshold
        unhealthyThreshold = var.health_check_unhealthy_threshold
        config = {
          type = "HTTP"
          httpHealthCheck = {
            portSpecification = "USE_SERVING_PORT"
            requestPath       = var.health_check_path
          }
        }
      }
      targetRef = {
        group = ""
        kind  = "Service"
        name  = local.service_name
      }
    }
  }
}