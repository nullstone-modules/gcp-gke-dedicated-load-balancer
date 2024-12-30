resource "kubernetes_manifest" "health-check-policy" {
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
