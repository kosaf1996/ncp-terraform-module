
resource "ncloud_server" "server" {
    for_each = var.server
        subnet_no                 = var.subnet_ids[each.value["subnet"]]
        name                      = each.value["name"]
        server_image_product_code  = each.value["server_image_product_code"]
        server_product_code = each.value["server_product_code"]
        login_key_name            = var.loginkey_ids
        is_protect_server_termination = each.value["is_protect_server_termination"]
        fee_system_type_code = each.value["fee_system_type_code"] #시간요금 
        zone = each.value["zone"] 
}
