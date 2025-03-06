resource "ncloud_login_key" "loginkey" {
  key_name = var.key_name
}
resource "local_file" "key" {
  filename = "${ncloud_login_key.loginkey.key_name}.pem"
  content = ncloud_login_key.loginkey.private_key
}