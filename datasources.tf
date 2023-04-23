data "aws_ami" "fatih_ubuntu_ami" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-eks/k8s_1.18/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}