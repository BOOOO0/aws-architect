#resource "aws_instance" "seoul_server_1" {
#  ami                    = var.ubuntu_22_04_ami
#  instance_type          = var.t2_micro_instance_type
#  subnet_id              = aws_subnet.public_subnet_1.id
#  vpc_security_group_ids = [aws_security_group.seoul_instance_security_group.id]
#  key_name               = var.peering_test_key 

#  tags = {
#    Name = "seoul-server-1"
#  }
#}

#resource "aws_instance" "tokyo_server_1" {
#  provider = aws.tokyo
#  ami                    = var.ubuntu_22_04_ami_tokyo
#  instance_type          = var.t2_micro_instance_type
#  subnet_id              = aws_subnet.public_subnet_2.id
#  vpc_security_group_ids = [aws_security_group.tokyo_instance_security_group.id]

#  tags = {
#    Name = "tokyo-server-1"
#  }
#}