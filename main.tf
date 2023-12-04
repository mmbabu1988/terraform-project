resource "aws_vpc" "info-tech-vpc" {
  cidr_block = "10.0.0.0/16"

 tags = {
  Name = "Info-Tech-VPC"
 }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.info-tech-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.info-tech-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_security_group" "info-tech-sg" {
  name        = "Info-Tech-SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.info-tech-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Info-Tech-SG"
  }
}

resource "aws_internet_gateway" "info-tech-igw" {
  vpc_id = aws_vpc.info-tech-vpc.id

  tags = {
    Name = "Info-Tech-IGW"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.info-tech-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.info-tech-igw.id
  }

  tags = {
    Name = "Public RT"
  }
}

resource "aws_route_table_association" "public-rt-asso" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_key_pair" "terraform-jen-key" {
  key_name   = "Terraform-Gen"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz6hh+OELPvc23bE/5w9AxYE1c0xd1gr4GOZTs9QtlLJD+tFSvvhxASnRDdgSKUru90AfM5huWHn6WUvrjCILnEqkBQ0mwd7Evfg8JmtjX2MCb3GFdWyLsBdyspWGvJCXpljxhq3+A0KQhfQU8yrKEWZUg+3u8+r0w/uGa2bU5E+mYWOQGOygkMaASbzko7DT1AMbXala/j8VQCSCIbXIKhFKh2LTYZ+yKOxPpCGxArkbudQfokgO8aPHmaURGNmfz2IqSXzb235A+SWRpLnhbB/XYRFlP+Xu8SzpzOiBpe0j/Jy5+FvyT/vZcXjH4dO//U6eNkoUZVk0OVw/arsRaeQDPIJS6BORGFG1QSyDX8gjDR2q7M/Fb8GJ08EvF/y4rkbtHsZbrirrE/kSIhySQyG6Krdnpghiv5JxPybKrcIedIgbJ4SvdeekZZ5V0w6E/54BDGFwZaLaDQr8ta0vstq5xIzRhcPHWa27aI4TOH5/PDfQiJ7y0fCwCxClUt6M= root@ip-172-31-47-185"
}

resource "aws_instance" "web-server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  key_name      = "Terraform-Gen"
  subnet_id     = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.info-tech-sg.id]


connection {
   type     = "ssh"
   host     = self.public-ip
   user     = ec2-user
 }

 tags = {
   Name = "Web-Server"
 }
}

resource "aws_eip" "info-tech-aws-eip" {
  instance = aws_instance.web-server.id
  domain   = "vpc"
}
