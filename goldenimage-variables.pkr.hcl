variable "base_path" {
    type = string
    default = "s3://bootstrap-opinion-stg/AppRole"
}

variable "tag" {
  type    = string
}

variable "app" {
  type    = string
  default = "grafana"
}

variable "extra" {
  default = {
    private_domain = "${aws_profile}.local"
  }
}

variable "aws_profile" {
  default = "opinion-stg"
}