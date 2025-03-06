
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
    test1-subnet-db = {
      vpc    = "test1"
      subnet = "10.0.3.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PRIVATE" #PUBLIC or PRIVATE
      name   = "test1-subnet-db"
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
    test1-subnet-lb-pub = {
      vpc    = "test1"
      subnet = "10.0.150.0/24"
      zone   = "KR-1"
      network_acl_no = "test1-nacl"
      subnet_type = "PUBLIC" #PUBLIC or PRIVATE
      name   = "test1-subnet-lb-pub"
      usage_type = "LOADB" #GEN 일반, LOADB 로드밸런서, BM 베어메탈, NATGW NAT Gateway
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
    test1-db-server = {
      subnet = "test1-subnet-db"
      name = "test1-db-server"
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

  }
  server_ids = { for k, v in module.server.server_details : k => v.id }

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