variable "cidr_vpc1" {
  default = "10.0.0.0/16"
}

variable "cidr_vpc2" {
  default = "172.5.0.0/16"
}

# 1번 퍼블릭 서브넷에 할당할 IP 대역
variable "cidr_public_subnet_2" {
  default = "10.0.0.0/24"
}

# 1번 프라이빗 서브넷에 할당할 IP 대역
variable "cidr_private_subnet_2" {
  default = "10.0.1.0/24"
}

# 2번 퍼블릭 서브넷에 할당할 IP 대역
variable "cidr_public_subnet_1" {
  default = "172.5.0.0/24"
}

# 2번 프라이빗 서브넷에 할당할 IP 대역
variable "cidr_private_subnet_1" {
  default = "172.5.1.0/24"
}

variable "ubuntu_22_04_ami" {
  default = "ami-0c9c942bd7bf113a2"
}

variable "ubuntu_22_04_ami_tokyo" {
  default = "ami-07c589821f2b353aa"
}

variable "t2_micro_instance_type" {
  default = "t2.micro"
}

variable "peering_test_key" {
  default = "peering_test_key1"
}