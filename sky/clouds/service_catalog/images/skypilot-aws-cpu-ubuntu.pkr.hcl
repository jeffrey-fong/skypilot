variable "region" {
  type    = string
  default = "us-east-1"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "cpu-ubuntu" {
  ami_name      = "skypilot-aws-cpu-ubuntu-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  ssh_username  = "ubuntu"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }
}

build {
  name    = "aws-cpu-ubuntu-build"
  sources = ["sources.amazon-ebs.cpu-ubuntu"]
  provisioner "shell" {
    script = "./provisioners/docker.sh"
  }
  provisioner "shell" {
    script = "./provisioners/skypilot.sh"
  }
  provisioner "shell" {
    environment_vars = [
      "CLOUD=aws",
    ]
    script = "./provisioners/cloud.sh"
  }
}
