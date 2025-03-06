
# DOC : https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs

####################################### INIT #######################################
############################
##          Main          ##
############################
##access_Key
variable access_key { 
    default = ""
}
##secret_key
variable secret_key {
    default = ""
}
##regin
## NCP Type
# KR 일반
# KR 공공
# FKR 금융 
variable region {
    default = "KR"
}
##NCP 
## NCP Type
# pub 일반
# gov 공공
# fin 금융 
variable site {
    default = "pub"
}

##platform 
variable support_vpc {
    default = "true" #VPC
    #default = "false" #Classic
}
####################################### NETWORK #######################################

############################
##           VPC          ##
############################

module "vpc" {
  #source = "../../modules/vpc"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/vpc"
  vpc = {
    test1 = {
      name = "test1"
      cidr = "10.0.0.0/16"
    }
    test2 = {
      name = "test2"
      cidr = "192.168.0.0/16"
    }
  }
}


############################
##           NACL         ##
############################

module "nacl" {
  #source = "../../modules/nacl"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/nacl"

  nacl = {
    test1-nacl = {
      vpc = "test1"
      name = "test1-nacl"
    }
    test2-nacl = {
      vpc = "test2"
      name = "test2-nacl"
    }
  }

  vpc_ids = { for k, v in module.vpc.vpc_details : k => v.vpc_no }  # VPC 모듈에서 ID 값 전달
}


############################
##          SubNet        ##
############################

module "subnet" {
  #source = "../../modules/subnet"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/subnet"

  subnet = {
    test1-subnet-pub = {
      vpc    = "test1"
      subnet = "10.0.1.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PUBLIC" #PUBLIC or PRIVATE
      name   = "test1-subnet-pub"
      usage_type = "GEN" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
      
    }
    test1-subnet-pri = {
      vpc    = "test1"
      subnet = "10.0.2.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PRIVATE" #PUBLIC or PRIVATE
      name   = "test1-subnet-pri"
      usage_type = "GEN" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
    test1-subnet-nat = {
      vpc    = "test1"
      subnet = "10.0.200.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PUBLIC" #PUBLIC or PRIVATE
      name   = "test1-subnet-nat"
      usage_type = "NATGW" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
    test1-subnet-nks-pri = {
      vpc    = "test1"
      subnet = "10.0.210.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PRIVATE" #PUBLIC or PRIVATE
      name   = "test1-subnet-nks-pri"
      usage_type = "GEN" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
    test1-subnet-nks-pub = {
      vpc    = "test1"
      subnet = "10.0.220.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PUBLIC" #PUBLIC or PRIVATE
      name   = "test1-subnet-nks-pub"
      usage_type = "NATGW" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
    test1-subnet-lb-pub = {
      vpc    = "test1"
      subnet = "10.0.150.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PUBLIC" #PUBLIC or PRIVATE
      name   = "test1-subnet-lb-pub"
      usage_type = "LOADB" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
    test1-subnet-lb-pri = {
      vpc    = "test1"
      subnet = "10.0.151.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PRIVATE" #PUBLIC or PRIVATE
      name   = "test1-subnet-lb-pri"
      usage_type = "LOADB" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
    test2-subnet-pub = {
      vpc    = "test2"
      subnet = "192.168.23.0/24"
      zone   = "KR-1"
      network_acl_no = "test2-nacl"
      subnet_type = "PUBLIC" #PUBLIC or PRIVATE
      name   = "test2-subnet-pub"
      usage_type = "GEN" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
    test2-subnet-pri = {
      vpc    = "test2"
      subnet = "192.168.2.0/24"
      zone   = "KR-1"
      network_acl_no = "test2-nacl"
      subnet_type = "PRIVATE" #PUBLIC or PRIVATE
      name   = "test2-subnet-pri"
      usage_type = "GEN" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
    test2-subnet-nat = {
      vpc    = "test2"
      subnet = "192.168.200.0/24"
      zone   = "KR-1"
      network_acl_no = "test2-nacl"
      subnet_type = "PUBLIC" #PUBLIC or PRIVATE
      name   = "test2-subnet-nat"
      usage_type = "NATGW" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
    }
  }
  vpc_ids = { for k, v in module.vpc.vpc_details : k => v.vpc_no }  # VPC 모듈에서 ID 값 전달
  nacl_ids = { for k, v in module.nacl.nacl_details : k => v.id }  # NACL 모듈에서 ID 값 전달
}


####################################### NAT GATEWAY #######################################

############################
##      NAT Gateway       ##
############################

module "nat-gateway" {
  #source = "../../modules/nat-gateway"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/nat-gateway"

  nat-gateway = {
    test1-nat-gateway = {
      vpc = "test1"
      subnet = "test1-subnet-nat"
      name = "test1-nat-gateway"
      zone = "KR-1"
    }
    test2-nat-gateway = {
      vpc = "test2"
      subnet = "test2-subnet-nat"
      name = "test2-nat-gateway"
      zone = "KR-1"
    }
  }
  vpc_ids = { for k, v in module.vpc.vpc_details : k => v.vpc_no }  # VPC 모듈에서 ID 값 전달
  subnet_ids = { for k, v in module.subnet.subnet_details : k => v.id }  # Subnet 모듈에서 ID 값 전달
}

############################
##     NAT Route Table    ##
############################
module "nat-route-table" {
    #source = "../../modules/nat-route-table"
    source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/nat-route-table"

    nat-route-table = {
        test1-nat-route-table = {
            vpc = "test1"
            destination_cidr_block = "0.0.0.0/0"
            target_type = "NATGW"
            target_name = "test1-nat-gateway"
        }
        test2-nat-route-table = {
            vpc = "test2"
            destination_cidr_block = "0.0.0.0/0"
            target_type = "NATGW"
            target_name = "test2-nat-gateway"
        }
    }
    # Private Route Table = default_private_route_table_no
    # Public Route Table = default_public_route_table_no
    route_table_ids = { for k, v in module.vpc.vpc_details : k => v.default_private_route_table_no }  # VPC 모듈에서 ID 값 전달
    nat_gateway_ids = { for k, v in module.nat-gateway.nat_gateway_details : k => v.id }  # NAT Gateway 모듈에서 ID 값 전달

}


####################################### SERVER #######################################
############################
##           ACG          ##
############################

module "acg" {
  #source = "../../modules/acg"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/acg"

  acg = {
    test1-web = {
      vpc = "test1"
      name = "test1-web"
    }
    test1-was = {
      vpc = "test1"
      name = "test1-was"
    }
    test1-db = {
      vpc = "test1"
      name = "test1-db"
    }
    test2-web = {
      vpc = "test2"
      name = "test2-web"
    }
    test2-was = {
      vpc = "test2"
      name = "test2-was"
    }
    test2-db = {
      vpc = "test2"
      name = "test2-db"
    }
  }
  vpc_ids = { for k, v in module.vpc.vpc_details : k => v.vpc_no }  # VPC 모듈에서 ID 값 전달
  
}

############################
##        ACG Rule        ##
############################

module "acg_rules" {
  #source = "../../modules/acg-rule"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/acg-rule"

  acg-rule = {
    test1-web = {
      acg = "test1-web"
      inbound_rules = [
        {
          protocol    = "TCP"
          ip_block    = "0.0.0.0/0"
          port_range  = "22"
          description = "accept SSH"
        },
        {
          protocol    = "TCP"
          ip_block    = "0.0.0.0/0"
          port_range  = "80"
          description = "accept HTTP"
        }
      ]
      outbound_rules = [
        {
          protocol    = "TCP"
          ip_block    = "0.0.0.0/0"
          port_range  = "1-65535"
          description = "accept all outbound traffic"
        }
      ]
    },
    test1-was = {
      acg = "test1-was"
      inbound_rules = [
        {
          protocol    = "TCP"
          ip_block    = "192.168.1.0/24"
          port_range  = "443"
          description = "accept HTTPS from internal network"
        }
      ]
      outbound_rules = [
        {
          protocol    = "TCP"
          ip_block    = "0.0.0.0/0"
          port_range  = "1-65535"
          description = "accept all outbound traffic"
        }
      ]
    }
  }
  acg_ids = { for k, v in module.acg.acg_details : k => v.id }  # VPC 모듈에서 ID 값 전달
}

module "pem-key" {
  #source = "../../modules/pem-key"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/pem-key"

  key_name = "terraform-pem"
  
}



############################
##        KVM Server      ##
############################


## 서버이미지 코드
########################################################################################################################################################################################################
# | Server Spec Code | vCPU | Memory (GB)| Block Storage Max IOPS | Block Storage Max Throughput (MB/s) | Network Performance (Gbps) |                           Description                           |
# |------------------|------|------------|------------------------|-------------------------------------|----------------------------|-----------------------------------------------------------------|
# | mi1-g3           | 1    | 1          | 100                    | 10                                  | 1                          | vCPU 1EA, Memory 1GB                                            |
# | ci2-g3           | 2    | 4          | 5,250                  | 81                                  | 1                          | vCPU 2EA, Memory 4GB                                            |
# | c2-g3            | 2    | 4          | 5,250                  | 81                                  | 1                          | vCPU 2EA, Memory 4GB                                            |
# | s2-g3            | 2    | 8          | 4,725                  | 81                                  | 1                          | vCPU 2EA, Memory 8GB                                            |
# | m2-g3            | 2    | 16         | 4,725                  | 81                                  | 1                          | vCPU 2EA, Memory 16GB                                           |
# | ci4-g3           | 4    | 8          | 7,875                  | 144                                 | 1                          | vCPU 4EA, Memory 8GB                                            |
# | c4-g3            | 4    | 8          | 7,875                  | 144                                 | 1                          | vCPU 4EA, Memory 8GB                                            |
# | s4-g3            | 4    | 16         | 7,875                  | 144                                 | 1                          | vCPU 4EA, Memory 16GB                                           |
# | m4-g3            | 4    | 32         | 7,875                  | 144                                 | 2                          | vCPU 4EA, Memory 32GB                                           |
# | sfc4-g3          | 4    | 16         | 7,875                  | 144                                 | 2                          | vCPU 4EA, Memory 16GB                                           |
# | ci8-g3           | 8    | 16         | 15,000                 | 288                                 | 1                          | vCPU 8EA, Memory 16GB                                           |
# | c8-g3            | 8    | 16         | 15,000                 | 288                                 | 1                          | vCPU 8EA, Memory 16GB                                           |
# | s8-g3            | 8    | 32         | 15,000                 | 288                                 | 2                          | vCPU 8EA, Memory 32GB                                           |
# | m8-g3            | 8    | 64         | 15,000                 | 288                                 | 2                          | vCPU 8EA, Memory 64GB                                           |
# | sfc8-g3          | 8    | 32         | 15,000                 | 288                                 | 4                          | vCPU 8EA, Memory 32GB                                           |
# | ci16-g3          | 16   | 32         | 25,000                 | 594                                 | 2                          | vCPU 16EA, Memory 32GB                                          |
# | c16-g3           | 16   | 32         | 25,000                 | 594                                 | 2                          | vCPU 16EA, Memory 32GB                                          |
# | s16-g3           | 16   | 64         | 25,000                 | 594                                 | 2                          | vCPU 16EA, Memory 64GB                                          |
# | m16-g3           | 16   | 128        | 25,000                 | 594                                 | 5                          | vCPU 16EA, Memory 128GB                                         |
# | sfc16-g3         | 16   | 64         | 25,000                 | 594                                 | 8                          | vCPU 16EA, Memory 64GB                                          |
# | ci32-g3          | 32   | 64         | 40,000                 | 850                                 | 2                          | vCPU 32EA, Memory 64GB                                          |
# | c32-g3           | 32   | 64         | 40,000                 | 850                                 | 2                          | vCPU 32EA, Memory 64GB                                          |
# | s32-g3           | 32   | 128        | 40,000                 | 850                                 | 5                          | vCPU 32EA, Memory 128GB                                         |
# | m32-g3           | 32   | 256        | 40,000                 | 850                                 | 10                         | vCPU 32EA, Memory 256GB                                         |
# | gp1ls32-g3       | 32   | 96         | -                      | -                                   | -                          | NVIDIA L40S GPU 1EA, GPUMemory 48GB, vCPU 32EA, Memory 96GB     |
# | ci48-g3          | 48   | 96         | 70,000                 | 1,188                               | 5                          | vCPU 48EA, Memory 96GB                                          |
# | c48-g3           | 48   | 96         | 70,000                 | 1,188                               | 2                          | vCPU 48EA, Memory 96GB                                          |
# | s48-g3           | 48   | 192        | 70,000                 | 1,188                               | 5                          | vCPU 48EA, Memory 192GB                                         |
# | m48-g3           | 48   | 384        | 70,000                 | 1,188                               | 10                         | vCPU 48EA, Memory 384GB                                         |
# | ci64-g3          | 64   | 128        | 100,000                | 1,188                               | 10                         | vCPU 64EA, Memory 128GB                                         |
# | c64-g3           | 64   | 128        | 100,000                | 1,188                               | 5                          | vCPU 64EA, Memory 128GB                                         |
# | s64-g3           | 64   | 256        | 100,000                | 1,188                               | 10                         | vCPU 64EA, Memory 256GB                                         |
# | gp8ap56-g3       | 56   | 1,920      | 100,000                | 1,188                               | 10                         | NVIDIA A100P GPU 8EA, GPUMemory 40GB, vCPU 56EA, Memory 1,920GB |
########################################################################################################################################################################################################



### KVM
# module "server" {
#   source = "../../modules/server/kvm"
#   source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/server/kvm"
#   server = {
#     test1-web = {
#       subnet = "test1-subnet-pub"
#       name = "test1-web-server"
#       server_image_name = "rocky-8.10-base" #서버 이미지
#       server_spec_code = "m2-g3" #서버 스펙 
#       login_key_name = "terraform-pem"
#       is_protect_server_termination = "false" #반납 보호  true or false
#       fee_system_type_code =  "MTRAT"  #시간요금 : MTRAT #월 요금 :FXSUM
#       zone = "KR-1"
#     }
#     test1-was = {
#       subnet = "test1-subnet-pub"
#       name = "test1-was-server"
#       server_image_name = "rocky-9.4-base" #서버 이미지
#       server_spec_code = "m2-g3" #서버 스펙 
#       login_key_name = "terraform-pem"
#       is_protect_server_termination = "false" #반납 보호  true or false
#       fee_system_type_code =  "MTRAT"  #시간요금 : MTRAT #월 요금 :FXSUM
#       zone = "KR-1"
#     }
#     test2-web = {
#       subnet = "test2-subnet-pub"
#       name = "test2-web-server"
#       server_image_name = "rocky-8.10-base" #서버 이미지
#       server_spec_code = "ci4-g3" #서버 스펙 
#       login_key_name = "terraform-pem"
#       is_protect_server_termination = "false" #반납 보호  true or false
#       fee_system_type_code =  "MTRAT"  #시간요금 : MTRAT #월 요금 :FXSUM
#       zone = "KR-1"
#     }
#     test2-was = {
#       subnet = "test2-subnet-pub"
#       name = "test2-was-server"
#       server_image_name = "ubuntu-20.04-base" #서버 이미지
#       server_spec_code = "ci4-g3" #서버 스펙 
#       login_key_name = "terraform-pem"
#       is_protect_server_termination = "false" #반납 보호  true or false
#       fee_system_type_code =  "MTRAT"  #시간요금 : MTRAT #월 요금 :FXSUM
#       zone = "KR-1"
#     }

#   }
#   subnet_ids = { for k, v in module.subnet.subnet_details : k => v.id }
#   loginkey_ids = module.pem-key.key_details.id 
# }

############################
##        XEN Server      ##
############################

## 서버이미지 코드 확인경로
# https://github.com/NaverCloudPlatform/terraform-ncloud-docs/blob/main/docs/server_image_product.md

module "server" {
  #source = "../../modules/server/xen"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/server/xen"

  server = {
    test1-web-server = {
      subnet = "test1-subnet-pub"
      name = "test1-web-server"
      server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" #서버 이미지
      server_product_code = "SVR.VSVR.HICPU.C004.M008.NET.HDD.B050.G002" #서버 스펙 
      login_key_name = "terraform-pem"
      is_protect_server_termination = "false" #반납 보호  true or false
      fee_system_type_code =  "MTRAT"  #시간요금 : MTRAT #월 요금 :FXSUM
      zone = "KR-1"
    }
    test1-was-server = {
      subnet = "test1-subnet-pub"
      name = "test1-was-server"
      server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" #서버 이미지
      server_product_code = "SVR.VSVR.HICPU.C004.M008.NET.HDD.B050.G002" #서버 스펙 
      login_key_name = "terraform-pem"
      is_protect_server_termination = "false" #반납 보호  true or false
      fee_system_type_code =  "MTRAT"  #시간요금 : MTRAT #월 요금 :FXSUM
      zone = "KR-1"
    }
    test2-web-server = {
      subnet = "test2-subnet-pub"
      name = "test2-web-server"
      server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" #서버 이미지
      server_product_code = "SVR.VSVR.HICPU.C004.M008.NET.HDD.B050.G002" #서버 스펙 
      login_key_name = "terraform-pem"
      is_protect_server_termination = "false" #반납 보호  true or false
      fee_system_type_code =  "MTRAT"  #시간요금 : MTRAT #월 요금 :FXSUM
      zone = "KR-1"
    }
    test2-was-server = {
      subnet = "test2-subnet-pub"
      name = "test2-was-server"
      server_image_product_code = "SW.VSVR.OS.LNX64.ROCKY.0810.B050" #서버 이미지
      server_product_code = "SVR.VSVR.HICPU.C004.M008.NET.HDD.B050.G002" #서버 스펙 
      login_key_name = "terraform-pem"
      is_protect_server_termination = "false" #반납 보호  true or false
      fee_system_type_code =  "MTRAT"  #시간요금 : MTRAT #월 요금 :FXSUM
      zone = "KR-1"
    }
  }
  subnet_ids = { for k, v in module.subnet.subnet_details : k => v.id }
  loginkey_ids = module.pem-key.key_details.id 
}

####################################### STORAGE #######################################

############################
##    KVM Block Storage   ##
############################


# <--------  작업 필요 ------------------>

############################
##    XEN Block Storage   ##
############################

module "block-storage" {
  #source = "../../modules/block-storage/xen"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/block-storage/xen"

  block-storage = {
    test1-web-block1 = {
      size = "30" #Disk Size
      server = "test1-web-server" #할당 서버 네임 
      name = "test1-web-block1" #Storage Name
      volume_type = "SSD" #Disk Type SSD, HDD
    }
    test2-web-block1 = {
      size = "20" #Disk Size
      server = "test2-web-server" #할당 서버 네임 
      name = "test2-web-block1" #Storage Name
      volume_type = "SSD" #Disk Type SSD, HDD
    }
  }
  server_ids = { for k, v in module.server.server_details : k => v.id }

}


############################
##     Object Storage     ##
############################

module "object-storage" {
  #source = "../../modules/object-storage"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/object-storage"

  object-storage = {
    bucket-test1 = {
      bucket_name = "bucket-test1-gm-tf"
    }
    bucket-test2 = {
      bucket_name = "bucket-test2-gm-tf"
    }
  }  
}

############################
##       NAS Stroage      ##
############################

module "nas-storage" {
  #source = "../../modules/nas-storage"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/nas-storage"

  nas-storage = {
    test1nas01 = {
      nas_name = "test1nas01"
      volume_size = "500"
    }
  }
}


####################################### LOADBALANCER #######################################

############################
##      LoadBalancer      ##
############################

module "lb" {
  #source = "../../modules/loadbalancer"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/loadbalancer"

  lb = {
    test1-alb = {
      lb_name = "test1-alb"
      lb_network = "PUBLIC" # PUBLIC | PRIVATE
      lb_type = "APPLICATION" #APPLICATION | NETWORK | NETWORK_PROXY
      lb_size = "SMALL" #SMALL | MEDIUM | LARGE | DYNAMIC | XLARGE
      subnet = ["test1-subnet-lb-pub"]
    }
  }
  subnet_ids = { for k, v in module.subnet.subnet_details : k => v.id }
}

############################
##     LoadBalancer TG    ##
############################

module "lb-tg" {
  #source = "../../modules/loadbalancer-target-group"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/loadbalancer-target-group"
  

  lb-tg = {
    test1-alb-http-80 = {
      name = "test1-alb-http-80"
      vpc = "test1"
      protocol = "HTTP"  #TCP | UDP | PROXY_TCP | HTTP | HTTPS
      port = "80"
      algorithm_type = "RR" #RR(Round Robin) | SIPHS(Source IP Hash) | LC(Least Connection) | MH(Maglev Hash).

      #health_check Info
      health_protocol = "HTTP" 
      health_http_method = "GET"
      health_port = "80"
      health_url_path = "/"
      health_cycle = "30"
      health_up_threshold = "2"
      health_down_threshold = "2"
    }

  }
  vpc_ids = { for k, v in module.vpc.vpc_details : k => v.id }
}

############################
## LoadBalancer TG Attach ##
############################
module "lb-tg-attach" {
  #source = "../../modules/loadbalancer-target-group-attachment"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/loadbalancer-target-group-attachment"

  lb-tg-attach = {
    test1-alb-http-80 = {
      lb-tg = "test1-alb-http-80"
      server = ["test1-web-server", "test1-was-server"]
    }
  }
  server_ids = { for k, v in module.server.server_details : k => v.id }
  tg_ids = { for k, v in module.lb-tg.lb_tg_details : k => v.id }
}

############################
## LoadBalancer Listener  ##
############################
module "lb-listener" {
  #source = "../../modules/loadbalancer-listener"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/loadbalancer-listener"


  lb-listener = {
    test1-alb = {
      lb = "test1-alb"
      protocol = "HTTP"
      port = "80"
      lb-tg = "test1-alb-http-80"
    }
  }
  lb_ids = { for k, v in module.lb.lb_details : k => v.id }
  lb_tg_ids = { for k, v in module.lb-tg.lb_tg_details : k => v.id }
}

####################################### Naver Kubernetes Service #######################################
module "nks-cluster" {
  #source = "../../modules/nks-cluster"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/nks-cluster"

  nks-cluster = {
    terraform-nks ={
      k8s_version = "1.29.9"
      login_key_name = "terraform-pem"
      name = "terraform-nks"
      lb_private_subnet = "test1-subnet-lb-pri"
      lb_public_subnet = "test1-subnet-lb-pub"
      subnet_no_list = ["test1-subnet-nks-pri"]
      vpc = "test1"
      public_network = false #Public Subnet Network 여부
      zone = "KR-1"
      audit = false #Audit Log 활성화 여부 
    }
  }
  loginkey_ids = module.pem-key.key_details.id 
  vpc_ids = { for k, v in module.vpc.vpc_details : k => v.id }
  subnet_ids = { for k, v in module.subnet.subnet_details : k => v.id }
}


module "nks-nodepool" {
  #source = "../../modules/nks-nodepool"
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/nks-nodepool"

  nks-nodepool = {
    nodepool1 = {
      nks-cluster = "terraform-nks"
      nodepool-name = "nodepool1"
      nodepool-count = "2"
      nodepool-os = "ubuntu-22.04"
      nodepool-spec = "s2-g3"
      nodepool-storage = "100"
      autoscale-bool = false
      autoscale-min = "2"
      autoscale-max = "2"
    }
    nodepool2 = {
      nks-cluster = "terraform-nks"
      nodepool-name = "nodepool2"
      nodepool-count = "2"
      nodepool-os = "ubuntu-22.04"
      nodepool-spec = "s2-g3"
      nodepool-storage = "100"
      autoscale-bool = false
      autoscale-min = "2"
      autoscale-max = "2"
    }

  }
  nks_cluster_ids = { for k, v in module.nks-cluster.nks_cluster_details : k => v.id }
}