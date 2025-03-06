output "key_details" {
  value = {
    id = ncloud_login_key.loginkey.id
  }
  description = "Details of the created PEM-KEY"
}
