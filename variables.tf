variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  service_name = var.app_metadata["service_name"]
  service_port = var.app_metadata["service_port"]
}

variable "enable_https" {
  description = "Enable this to serve up HTTPS traffic. Requires subdomain connection."
  type        = bool
  default     = true
}
