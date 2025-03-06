output "server_details" {
  value = {
    for k, v in ncloud_server.server : k => {
      id                                = v.id
      private_ip                        = v.private_ip
    }
  }
  description = "Details of the created KVM Server"
}