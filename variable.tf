variable "ec2_instance_type" {
    description = "The type of EC2 instance to create"
    type        = string
    default     = "t3.micro"
  
}

variable "ec2_ami" {
    description = "The AMI ID to use for the EC2 instance"
    type        = string
    default     = "ami-0b6d9d3d33ba97d99"
}

variable "root_storage_size" {
    description = "The size of the root storage volume in GB"
    type        = number
    default     = 15
}