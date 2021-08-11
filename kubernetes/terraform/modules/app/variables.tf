variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "fd8um61f5eu53jt7gshv"
}
variable "count_of_instance_app" {
  default = 2
}
variable public_key_path {
  default = "~/.ssh/appuser.pub"
}
variable subnet_id {
  description = "Subnets for modules"
}
