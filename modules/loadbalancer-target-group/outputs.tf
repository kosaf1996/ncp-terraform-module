output "lb_tg_details" {
  value = {
    for k, v in ncloud_lb_target_group.lb-tg : k => {
      id                                = v.id
      target_no_list                    = v.target_no_list 
      target_group_no                   = v.target_group_no 
      load_balancer_instance_no         = v.load_balancer_instance_no  
    }
  }
  description = "Details of the created LoadBalancer Target Group"
}