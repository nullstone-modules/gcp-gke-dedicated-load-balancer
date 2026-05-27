# 0.2.0 (May 27, 2026)
* Added `var.deprogram_secs` (default `60`) and `var.app_drain_secs` (default `15`).
* Added the `deployment_overrides` output (`preStop`, `terminationGracePeriodSeconds`) consumed by the attached app module for zero-downtime rollouts.
* Wired `HealthCheckPolicy` `checkIntervalSec`/`healthyThreshold`/`unhealthyThreshold` to the `health_check_*` variables (were hardcoded `15`/`1`/`5`).
* Changed `var.health_check_interval` default to `15` (was `5`) and `var.health_check_unhealthy_threshold` default to `5` (was `2`).
* Added a `HealthCheckPolicy` precondition: `health_check_unhealthy_threshold * health_check_interval >= deprogram_secs`.

# 0.1.7 (May 20, 2026)
* Added `var.post_app_metadata`.

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

