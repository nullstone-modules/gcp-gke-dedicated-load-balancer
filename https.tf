locals {
  certificate_name = local.resource_name
}

resource "kubernetes_manifest" "managed-certificate" {
  count = var.enable_https ? 1 : 0

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = local.certificate_name
      namespace = local.kubernetes_namespace
    }

    spec = {
      domains = [trimsuffix(local.subdomain_fqdn, ".")]
    }
  }
}

resource "kubernetes_ingress_v1" "https" {
  count = var.enable_https ? 1 : 0

  metadata {
    name      = local.resource_name
    namespace = local.kubernetes_namespace
    labels    = local.labels
    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.static-ip.name
      "networking.gke.io/managed-certificates"      = local.certificate_name
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

resource "kubernetes_manifest" "redirect-http-to-https" {
  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"

    metadata = {
      name      = local.resource_name
      namespace = local.kubernetes_namespace
    }

    spec = {
      sslPolicy = "gke-ingress-ssl-policy"

      redirectToHttps = {
        enabled = true
      }
    }
  }
}
