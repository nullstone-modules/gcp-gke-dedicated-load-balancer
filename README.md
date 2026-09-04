# gcp-gke-dedicated-load-balancer

Creates a GCP Load Balancer with HTTPS and forwards HTTP traffic to the attached Google Kubernetes (GKE) application.
This is commonly used to securely expose a GKE app to the internet.

## Subdomain connection

This module requires connection a subdomain.
The subdomain address is automatically connected to the created load balancer.

## HTTPS

When `enable_https` is set, the load balancer enforces TLS 1.2+ (GCP SSL policy profile `RESTRICTED`); clients on TLS 1.0/1.1 are rejected.

## Backend/Routes

This module creates a simple route configuration to forward all traffic from the load balancer to the Kubernetes Service that is created by the application module.

## Zero-downtime rollouts

Container-native (NEG) load balancing has a small race during rollouts: a pod stops serving the moment it terminates, but the load balancer takes tens of seconds to deprogram that endpoint. Traffic that arrives in between produces `connection termination` and `no healthy upstream` errors.

To eliminate this, the module exposes a `deployment_overrides` output that the attached app module applies to its Deployment:

- **`preStop` sleep** holds the listener open for `var.deprogram_secs` while the load balancer deprograms the endpoint.
- **`terminationGracePeriodSeconds`** is sized to `deprogram_secs + app_drain_secs`, giving in-flight requests time to finish after `preStop`.

The app module controls its own rolling update strategy (`maxSurge`/`maxUnavailable`) independently of this module.

Tuning:

- Increase `var.deprogram_secs` only if you observe deprogramming taking longer than 60s.
- Increase `var.app_drain_secs` for apps with long-lived requests (e.g. websockets, SSE) so the grace period covers their drain time.
- Set `var.deprogram_secs = 0` to opt out entirely; `deployment_overrides` becomes all-null and the app falls back to Kubernetes defaults.

> The application must still handle `SIGTERM` by gracefully draining and exiting. The `preStop` sleep and grace period only create the window for that drain to happen.

## Details

This utilizes GKE Gateway which is a Google's implementation of the [Kubernetes Gateway API](https://kubernetes.io/docs/concepts/services-networking/gateway/).
