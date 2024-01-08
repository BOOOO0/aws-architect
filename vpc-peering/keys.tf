# Key를 하나만 생성해서 한 리전에 접속한 후 다른 리전과의 통신을 확인만 하는 것으로
# provider를 도쿄 리전을 위해 명시해서 hashicorp/local, hashicorp/tls provider를 사용할 수 없음
# provider의 복수 선언은 불가능하나 처음 provider 명시에서 한 provider가 
# 여러 provider를 포함하도록 설정할 수 있을 것 같음

resource "tls_private_key" "private_key1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "peering_test_key1" {
  key_name   = "peering_test_key1"
  public_key = tls_private_key.private_key1.public_key_openssh
}

resource "local_file" "ssh_key1" {
  filename = "${aws_key_pair.peering_test_key1.key_name}.pem"
  content  = tls_private_key.private_key1.private_key_pem
  directory_permission = "0400"
  file_permission      = "0400"
}