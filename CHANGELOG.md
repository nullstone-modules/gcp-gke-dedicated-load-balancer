# 0.1.6 (Mar 20, 2026)
* Removed `var.request_timeout` because GKE Load Balancers don't support it yet.

# 0.1.5 (Mar 20, 2026)
* Fixed `var.request_timeout` type declaration.

# 0.1.4 (Mar 20, 2026)
* Added `var.request_timeout` to configure request timeouts.

# 0.1.3 (Feb 07, 2025)
* Restore `HealthCheckPolicy` to override the request path of the default GPC LB health check.

# 0.1.2 (Feb 06, 2025)
* Replace `HealthCheckPolicy` with a readiness probe to dictate healthy pod traffic.

# 0.1.1 (Dec 30, 2024)
* Added variables to configure load balancer health check against the service.

# 0.1.0 (Dec 13, 2024)
* Initial draft

