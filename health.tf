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
        checkIntervalSec   = 15
        timeoutSec         = var.health_check_timeout
        healthyThreshold   = 1
        unhealthyThreshold = 5
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