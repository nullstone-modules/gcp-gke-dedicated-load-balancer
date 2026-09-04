// Enforces TLS 1.2+ on the HTTPS Gateway listener.
resource "google_compute_ssl_policy" "this" {
  count = var.enable_https ? 1 : 0

  name            = local.resource_name
  min_tls_version = "TLS_1_2"
  profile         = "RESTRICTED"
}

resource "kubernetes_manifest" "gateway_policy" {
  count = var.enable_https ? 1 : 0

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "GCPGatewayPolicy"

    metadata = {
      name      = local.resource_name
      namespace = local.kubernetes_namespace
      labels    = local.labels
    }

    spec = {
      default = {
        sslPolicy = google_compute_ssl_policy.this[0].name
      }

      targetRef = {
        group = "gateway.networking.k8s.io"
        kind  = "Gateway"
        name  = local.resource_name
      }
    }
  }
}
