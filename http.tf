resource "kubernetes_manifest" "http-gateway" {
  count = var.enable_https ? 0 : 1

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "Gateway"

    metadata = {
      name      = local.resource_name
      namespace = local.kubernetes_namespace
      labels    = local.labels
    }

    spec = {
      gatewayClassName = "gke-l7-global-external-managed"

      listeners = [
        {
          name     = "http"
          protocol = "HTTP"
          port     = 80
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

resource "kubernetes_manifest" "http-to-service" {
  count      = var.enable_https ? 0 : 1
  depends_on = [kubernetes_manifest.http-gateway]

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "${local.resource_name}-http"
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
