output "subnet_details" {
  value = {
    for k, v in ncloud_subnet.subnet : k => {
      id                                = v.id
      subnet_no                         = v.subnet_no
      vpc_no                            = v.vpc_no
    }
  }
  description = "Details of the created Subnet"
}
