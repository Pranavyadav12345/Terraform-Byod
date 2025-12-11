# Lookup the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["137112412989"] # Amazon's official AMI owner ID
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  key_name               = aws_key_pair.mykey.key_name

  user_data = <<EOF
#!/bin/bash
# Amazon Linux 2 user-data: install, enable/start nginx and overwrite index
set -e

# Update package metadata (optional)
yum makecache fast || true

# Install nginx
yum install -y nginx

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Overwrite default Nginx welcome page with assignment HTML
cat > /usr/share/nginx/html/index.html <<HTML
<h1>Project Genesis SUCCESS! Deployed by Pranav</h1>
HTML

exit 0
EOF

  tags = {
    Name = "project-genesis-webserver"
  }
}
