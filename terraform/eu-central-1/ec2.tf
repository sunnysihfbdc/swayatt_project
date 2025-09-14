resource "aws_key_pair" "bastion_key_pair" {
  key_name   = "bastion-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPdmj16FrzOF0BlketRc4mvISITcQu7E0iTnkz+qPN9Q4BbWS3al8n27NwrY+JfpkvFMPr6dx9YkWQVZZCR2PXBTkUi076xTDA2+2NBT1W6p09u1vEhYlNGZlHisFf+mOE7KxLILOYdO5UIbt9bHl9BSImj9mITXX/dXYnB5LvP2QuW19SX5QSEsbyBesAXk4LVjRE4XPlur6LWYkLYRR7jumJvBNHz68UF0MHavxZsbovUgCLzfCqi03k/t8j5Vpvy7vPuTtpofMUyvpQHHW1+1ukYKQ8nRJNpbYXmp4fPIKe2AhoL52HMada1dN9B8jVeewsiizPy6il/GaGYUwUcueDJTy6Re/TGDxGYHN/I0Qwf9Rqq4lJTLzdE8LrRaYJINkzLJeCxYJza7ybckAsMlv7K5Cr98IjV41SyhNhuK4fyriOjI13EW99pomdDMRUdBgbI9xSQHv0bwovg50xCy17EWZFAWnXw7TkqazQ8LHcel1vmEPhepPXKCH2XU8= mohitbairagi@Mohits-MacBook-Pro.local"
}

resource "aws_instance" "bastion_host" {
  ami                    = "ami-0b74f796d330ab49c"
  instance_type          = "t3.micro"
  subnet_id              = module.compute_vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = aws_key_pair.bastion_key_pair.key_name

  iam_instance_profile = var.bastion_host_instance_profile_name

  tags = merge(
    { "Name" = "bastion-host" },
    var.tags
  )
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "Allow SSH access from the internet"
  vpc_id      = module.compute_vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { "Name" = "bastion-security-group" },
    var.tags
  )
}
