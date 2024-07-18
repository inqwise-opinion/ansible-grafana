// packer build -var 'tag=1.27.0' .
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = formatdate("YYYYMMDDhhmm", timestamp())
}

source "amazon-ebs" "amazon_linux2023" {
  force_deregister      = true
  force_delete_snapshot = true
  ami_name              = "${var.app}-${var.tag}"
  instance_type         = "t4g.small"
  region                = "us-west-2"
  ami_regions           = ["il-central-1"]
  encrypt_boot          = false
  ami_description       = "Image of ${var.app} version ${var.tag}"
  profile               = "${var.aws_profile}"
  iam_instance_profile  = "PackerRole"
  ssh_username = "ec2-user"

  source_ami_filter {
    filters = {
      name                = "al2023-*-kernel-6.1-arm64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  
  run_tags = {
    Name      = "${var.app}-${var.tag}-packer"
    app       = "${var.app}"
    version   = "${var.tag}"
    timestamp = "${local.timestamp}"
  }

  tags = {
    Name      = "${var.app}-${var.tag}"
    app       = "${var.app}"
    version   = "${var.tag}"
    timestamp = "${local.timestamp}"
  }
}

build {
  name = "packer"
  sources = [
    "source.amazon-ebs.amazon_linux2023"
  ]

  provisioner "shell" {
    inline = [
      "set -euxo pipefail",
      "echo 'download playbook'",
      "mkdir /tmp/deployment",
      "sudo aws s3 cp ${var.base_path}/ansible-${var.app}/${var.tag} /tmp/deployment --recursive",
      "sudo chmod -R 755 /tmp/deployment",
      "cd /tmp/deployment",
      "echo 'execute playbook'",
      "sudo bash main.sh -e ${jsonencode(jsonencode(var.extra))}"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
