output "block_storage_details" {
  value = {
    for k, v in ncloud_block_storage.storage : k => {
      id                                = v.id
      block_storage_no                  = v.block_storage_no
      max_iops                          = v.max_iops
      encrypted_volume                  = v.encrypted_volume
    }
  }
  description = "Details of the created Xen Server"
}