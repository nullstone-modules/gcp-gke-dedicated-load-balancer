data "ns_connection" "subdomain" {
  name     = "subdomain"
  contract = "subdomain/gcp/cloud-dns"
}

locals {
  subdomain_name       = data.ns_connection.subdomain.outputs.name
  subdomain_fqdn       = data.ns_connection.subdomain.outputs.fqdn
  subdomain_zone_id    = data.ns_connection.subdomain.outputs.zone_id
  certificate_map_name = data.ns_connection.subdomain.outputs.certificate_map_name
}
