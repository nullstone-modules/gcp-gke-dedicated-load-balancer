# gcp-gke-dedicated-load-balancer

Creates a GCP Load Balancer with HTTPS and forwards HTTP traffic to the attached Google Kubernetes (GKE) application.
This is commonly used to securely expose a GKE app to the internet.

## Subdomain connection

This module requires connection a subdomain.
The subdomain address is automatically connected to the created load balancer.

## Backend/Routes

This module creates a simple route configuration to forward all traffic from the load balancer to the Kubernetes Service that is created by the application module.

## Details

This utilizes GKE Gateway which is a Google's implementation of the [Kubernetes Gateway API](https://kubernetes.io/docs/concepts/services-networking/gateway/).
