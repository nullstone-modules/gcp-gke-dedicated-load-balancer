resource "kubernetes_ingress_v1" "http" {
  count = var.enable_https ? 0 : 1

  metadata {
    name      = local.resource_name
    namespace = local.kubernetes_namespace
    labels    = local.labels
    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.static-ip.name
    }
  }

  spec {
    default_backend {
      service {
        name = local.service_name
        port {
          number = local.service_port
        }
      }
    }
  }
}
