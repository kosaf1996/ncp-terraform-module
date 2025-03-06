output "lb_listener_details" {
  value = {
    for k, v in ncloud_lb_listener.listener : k => {
      id                           = v.id
      listener_no                  = v.listener_no
      rule_no_list                 = v.rule_no_list 
    }
  }
  description = "Details of the created LoadBalancer Listener"
}