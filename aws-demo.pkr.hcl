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
  source_ami = "ami-053b0d53c279acc90"
  ssh_username = "ubuntu"
  ami_regions =[
		"us-east-1"
  ]
}

build {
  name    = "packer-ubuntu"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
  provisioner "file" {

    source = "script.sh"
	destination = "/tmp/script.sh"
  }

  provisioner "shell" {

    inline = [
      "chmod +x /tmp/script.sh",
	  "/tmp/script.sh"
	  
    ]
  }
}
