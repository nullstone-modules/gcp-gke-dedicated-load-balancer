resource "kubernetes_manifest" "https-gateway" {
  count = var.enable_https ? 1 : 0

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "Gateway"

    metadata = {
      name      = local.resource_name
      namespace = local.kubernetes_namespace
      labels    = local.labels
      annotations = {
        "networking.gke.io/certmap" = local.certificate_map_name
      }
    }

    spec = {
      gatewayClassName = "gke-l7-global-external-managed"

      listeners = [
        {
          name     = "https"
          protocol = "HTTPS"
          port     = 443
        }
      ]

      addresses = [
        {
          type  = "NamedAddress"
          value = google_compute_global_address.static-ip.name
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "https-to-service" {
  count      = var.enable_https ? 1 : 0
  depends_on = [kubernetes_manifest.https-gateway]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "${local.resource_name}-https"
      namespace = local.kubernetes_namespace
      labels    = local.labels
    }

    spec = {
      parentRefs = [
        {
          kind      = "Gateway"
          name      = local.resource_name
          namespace = local.kubernetes_namespace
        }
      ]

      rules = [
        {
          matches = [
            {
              path = {
                type  = "Prefix"
                value = "/"
              }
            }
          ]

          backendRefs = [
            {
              name = local.service_name
              port = local.service_port
            }
          ]
        }
      ]
    }
  }
}
