# resource "ncloud_server" "server" {
#     for_each = var.server
#         subnet_no                 = var.subnet_ids[each.value["subnet"]]
#         name                      = each.value["name"]
#         server_image_product_code  = each.value["server_image_product_code"]
#         server_product_code = each.value["server_product_code"]
#         login_key_name            = var.loginkey_ids
#         is_protect_server_termination = each.value["is_protect_server_termination"]
#         fee_system_type_code = each.value["fee_system_type_code"] 
#         zone = each.value["zone"] 
# }

# 이미지 번호 가져오기
data "ncloud_server_image_numbers" "kvm-image" {
  for_each = var.server

  server_image_name = each.value.server_image_name
  filter {
    name = "hypervisor_type"
    values = ["KVM"]
  }
}

# 서버 스펙 가져오기
data "ncloud_server_specs" "kvm-spec" {
  for_each = var.server

  filter {
    name   = "server_spec_code"
    values = [each.value.server_spec_code]
  }

}

resource "ncloud_server" "server" {
    for_each = var.server
        subnet_no                 = var.subnet_ids[each.value["subnet"]]
        name                      = each.value["name"]
        server_image_number       = data.ncloud_server_image_numbers.kvm-image[each.key].image_number_list.0.server_image_number
        server_spec_code          = data.ncloud_server_specs.kvm-spec[each.key].server_spec_list.0.server_spec_code
        login_key_name            = var.loginkey_ids
        is_protect_server_termination = each.value["is_protect_server_termination"]
        fee_system_type_code = each.value["fee_system_type_code"] 
        zone = each.value["zone"] 

}