variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  service_name   = var.app_metadata["service_name"]
  service_port   = var.app_metadata["service_port"]
  container_port = var.app_metadata["container_port"]
}

variable "enable_https" {
  description = "Enable this to serve up HTTPS traffic. Requires subdomain connection."
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "The path to check for health."
  type        = string
  default     = "/"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive successful health checks required before considering an unhealthy target healthy."
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive failed health checks required before considering a target unhealthy."
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target."
  type        = number
  default     = 12
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check."
  type        = number
  default     = 4
}

variable "deprogram_secs" {
  description = <<EOF
The window, in seconds, that the GCP load balancer takes to deprogram (stop sending traffic to) a backend endpoint after a pod begins terminating.
This drives the pod `preStop` sleep so the container keeps serving while the LB drains it, eliminating brief downtime during rollouts.
Set to `0` to disable the entire deployment override bundle (`deployment_overrides` becomes all-null and the service falls back to Kubernetes defaults).
EOF
  type        = number
  default     = 60
}

variable "app_drain_secs" {
  description = <<EOF
Additional buffer, in seconds, granted after SIGTERM for the application to finish in-flight requests (added on top of `deprogram_secs` to size `terminationGracePeriodSeconds`).
Tune this to your application's p99 request duration.
EOF
  type        = number
  default     = 15
}
