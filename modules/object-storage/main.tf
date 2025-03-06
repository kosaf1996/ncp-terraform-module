
resource "ncloud_objectstorage_bucket" "bucket" {
    for_each = var.object-storage
        bucket_name                = each.value["bucket_name"]
}
