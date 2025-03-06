output "lb_details" {
  value = {
    for k, v in ncloud_lb.lb : k => {
      id                                = v.id
      load_balancer_no                  = v.load_balancer_no
      domain                            = v.domain
      ip_list                           = v.ip_list 
    }
  }
  description = "Details of the created LoadBalancer"
}