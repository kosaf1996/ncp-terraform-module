output "object_storage_details" {
  value = {
    for k, v in ncloud_objectstorage_bucket.bucket : k => {
      id                                = v.id
      creation_date                     = v.creation_date
    }
  }
  description = "Details of the created Object Storage"
}