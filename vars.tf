variable "amis" {
  type = map

  default = {
    "sa-east-1": "ami-05240a8eacac22db2"
  }
}

variable "cidr_blocks" {
    type = list

    default = ["0.0.0.0/0"]
}