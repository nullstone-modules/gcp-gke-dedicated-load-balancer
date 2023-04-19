resource "google_compute_global_address" "static-ip" {
  name = local.resource_name
}
