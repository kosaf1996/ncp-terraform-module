output "lb_tg_attach_details" {
  value = {
    for k, v in ncloud_lb_target_group_attachment.lb-tg-attach : k => {
      target_group_no                    = v.target_group_no
      target_no_list                     = v.target_no_list  
    }
  }
  description = "Details of the created LoadBalancer Target Group Attachment"
}