packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


variable "ami_prefix" {
  type    = string
  default = "packer-aws-ubuntu-java"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-ubuntu-aws-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "packer-ubuntu"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
  provisioner "file" {

    source = "script.sh",
	destination = "/tmp/script.sh"
  }

  provisioner "shell" {

    inline = [
      "chmod +x /tmp/script.sh",
	  "tmp/script.sh"
	  
    ]
  }
}
