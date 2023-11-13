variable "ami_id" {
  type    = string
  default = "ami-0287a05f0ef0e9d9a"
}

variable "efs_mount_point" {
  type    = string
  default = "fs-0061ae451e941001d.efs.ap-south-1.amazonaws.com"
}

variable "region" {
    type = string
    default = "ap-south-1"
}

variable "availability_zone" {
    type = string
    default = "ap-south-1a"
}

locals {
  app_name = "jenkins-controller"
}

source "amazon-ebs" "jenkins" {
  ami_name      = "${local.app_name}"
  instance_type = "t2.micro"
  region        = "${var.region}"
  availability_zone = "${var.availability_zone}"
  source_ami    = "${var.ami_id}"
  ssh_username  = "ubuntu"
  tags = {
    Env  = "dev"
    Name = "${local.app_name}"
  }
}

build {
  sources = ["source.amazon-ebs.jenkins"]

  provisioner "ansible" {
  playbook_file = "ansible/jenkins-controller.yaml"
  extra_arguments = [ "--extra-vars", "ami-id=${var.ami_id} efs_mount_point=${var.efs_mount_point}", "--scp-extra-args", "'-O'", "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa" ]
  } 
  
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}