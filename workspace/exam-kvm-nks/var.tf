
# DOC : https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs

####################################### NETWORK #######################################
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


############################
##           VPC          ##
############################

module "vpc" {
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
  source = "git::https://github.com/kosaf1996/ncp-terraform-module.git//modules/subnet"

  subnet = {
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
  }
  vpc_ids = { for k, v in module.vpc.vpc_details : k => v.vpc_no }  # VPC 모듈에서 ID 값 전달
  nacl_ids = { for k, v in module.nacl.nacl_details : k => v.id }  # NACL 모듈에서 ID 값 전달
}


####################################### NAT GATEWAY #######################################

############################
##      NAT Gateway       ##
############################

module "nat-gateway" {
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

module "pem-key" {
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

####################################### Naver Kubernetes Service #######################################
module "nks-cluster" {
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