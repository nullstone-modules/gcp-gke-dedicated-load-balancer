resource "google_dns_record_set" "this" {
  managed_zone = local.subdomain_zone_id
  name         = local.subdomain_fqdn
  rrdatas      = [google_compute_global_address.static-ip.address]
  type         = "A"
  ttl          = 300
}
