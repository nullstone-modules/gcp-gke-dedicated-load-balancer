terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

// Generate a random suffix to ensure uniqueness of resources
resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  numeric = false
  special = false
}

locals {
  tags          = data.ns_workspace.this.tags
  stack_name    = data.ns_workspace.this.stack_name
  block_ref     = data.ns_workspace.this.block_ref
  env_name      = data.ns_workspace.this.env_name
  resource_name = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"

  match_app_labels = {
    "nullstone.io/stack"     = data.ns_workspace.this.stack_name
    "nullstone.io/block-ref" = data.ns_workspace.this.block_ref
    "nullstone.io/env"       = data.ns_workspace.this.env_name
  }

  labels = {
    // k8s-recommended labels
    "app.kubernetes.io/name"       = local.block_name
    "app.kubernetes.io/version"    = ""
    "app.kubernetes.io/component"  = "load-balancer"
    "app.kubernetes.io/part-of"    = local.stack_name
    "app.kubernetes.io/managed-by" = "nullstone"
    // nullstone labels
    "nullstone.io/stack" = local.stack_name
    "nullstone.io/env"   = local.env_name
  }
}
