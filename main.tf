resource "aws_vpc" "fatih_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "fatih_dev"
  }
}

resource "aws_subnet" "fatih_public_subnet" {
  vpc_id                  = aws_vpc.fatih_vpc.id
  cidr_block              = "10.123.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = local.common_tags
}

resource "aws_internet_gateway" "fatih_internet_gateway" {
  vpc_id = aws_vpc.fatih_vpc.id

  tags = {
    Name = "fatih_internet_gateway"
  }
}

resource "aws_route_table" "fatih_route_table" {
  vpc_id = aws_vpc.fatih_vpc.id

  tags = {
    Name = "fatih_dev_public_rt"
  }
}

resource "aws_route" "fatih_route" {
  route_table_id         = aws_route_table.fatih_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.fatih_internet_gateway.id
}

resource "aws_route_table_association" "fatih_route_table_association" {
  subnet_id      = aws_subnet.fatih_public_subnet.id
  route_table_id = aws_route_table.fatih_route_table.id
}

resource "aws_security_group" "fatih_allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.fatih_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_key_pair" "fatih_auth" {
  key_name   = "benim_anahtarim"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILTx8mdP55s2AEhVWHd4aQAxRvimfI2fXg2W6KhHpIqm rise\\fatih.aydin@FatihAydin"
}

resource "aws_instance" "fatih_instance" {
    instance_type = "t2.micro"
    ami = data.aws_ami.fatih_ubuntu_ami.id
    key_name = aws_key_pair.fatih_auth.id
    vpc_security_group_ids = [aws_security_group.fatih_allow_tls.id]
    subnet_id = aws_subnet.fatih_public_subnet.id
    user_data = file("userdata.tpl")

    tags = {
        name = "fatih-instance"
    }

    root_block_device {
        volume_size = 20
    }

    provisioner "local-exec" {
     command = templatefile("windows-ssh-config.tpl", {
     hostname = self.public_ip,
     user = "ubuntu",
     identityfile = "c:/users/fatih.aydin/.ssh/fatihkey"
        })
    interpreter = ["PowerShell", "Command"]
    
}
}
