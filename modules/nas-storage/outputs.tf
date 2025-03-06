output "nas_storage_details" {
  value = {
    for k, v in ncloud_nas_volume.nas : k => {
      id                                = v.id
      nas_volume_no                     = v.nas_volume_no
      name                              = v.name
      volume_total_size                 = v.volume_total_size 
    }
  }
  description = "Details of the created NAS Storage"
}