terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
    access_key = "{Chave de Acesso IAM}"
    secret_key = "{Chave de Acesso IAM}"
    profile = "customprofile"
}

resource "aws_key_pair" "k8s-key" {
  key_name = "k8s-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOGPQ/tsLuJ3oz4ZthlDrZ4YTt9fJQxTHm+Pzc+58PZqIPHV+XQA+iO27qTxFac0iHyNapKkC0kqb80G0QB0JVTbzdz/vnqnXWXf8TtPCp/GLruDvNOCkYuxqXipkSkvipZmM1q6NZLtMKrS3N4lJZxWkzITc/ZM6GvZ/LcPS7qCGueYRoiPQ+2do64BMcsCKKenWrb56taCzTTfAguHRfutLCZBPUhaoMa0jlwnRJw6soA0jTcYZ0jDP7yNjixGxewOnDx2aEMN4FAxDW7CzQ5+gM8nczXMUmF+GsTjPdh+82jEAWiJ7QL/9DFsbGQXMyF+AIM1JA10CdMlDJK+z6qvNVUrphD+ibAvptm28fFDWX1HqD1Ys2mdKd6nThae0zpz8vh+G+NhhTwqdkeY3mqDR84Be6ChLP1zQ62NCeaA4QNF4WtBEJtrJMql5kHhZF4FsAdlIAyMbPsEdvIlA87mCCApjA5/2jM+4fZk4wzhz7wrqCB867pNV0b4kXIl0= felipe@fp-Box"
}

resource "aws_security_group" "k8s-sg" {

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }
    
    ingress {
        from_port = 22
        to_port  = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0 
        protocol = "-1"
    }

 }

resource "aws_instance" "k8s-worker" {
  ami           = "ami-085925f297f89fcel"
  instance_type = "t3.medium"
  key_name = "k8s-key"
  count = 2
  tags = {
    name = "k8s"
    type = "worker"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}


resource "aws_instance" "k8s-master" {
  ami           = "ami-085925f297f89fcel"
  instance_type = "t3.medium"
  key_name = "k8s-key"
  count = 1
  tags = {
    name = "k8s"
    type = "master"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"] 
}









