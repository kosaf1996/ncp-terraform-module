output "nat_gateway_details" {
  value = {
    for k, v in ncloud_nat_gateway.nat_gateway : k => {
      id                                = v.id
      nat_gateway_no                    = v.nat_gateway_no
      public_ip                         = v.public_ip
      public_ip_no                      = v.public_ip_no
      subnet_name                       = v.subnet_name
    }
  }
  description = "Details of the created NAT-Gateway"
}
