resource "kubernetes_manifest" "backend-policy" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "GCPBackendPolicy"

    metadata = {
      name      = local.resource_name
      namespace = local.kubernetes_namespace
      labels    = local.labels
    }

    spec = {
      default = {
        timeoutSec = var.backend_timeout
      }
      targetRef = {
        group = ""
        kind  = "Service"
        name  = local.service_name
      }
    }
  }
}
