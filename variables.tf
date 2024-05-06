variable "project_name" {
  type        = string
  description = "Project name"
}

variable "project_env" {
  type        = string
  description = "Project env"
}

variable "region" {
  type        = string
  description = "vpc region"
}


variable "ami" {
  type        = string
  description = "ami"
}

variable "instance_type" {
  type        = string
  description = "instance_type"
}


variable "public_hostname" {
  type        = string
  description = "public_hostname"
}
