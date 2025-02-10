variable "policy_name" {
    type = string
  
}

variable "policy_document" {
    type = string
  
}


variable "role_name" {
    type = string
  
}
variable "role_tags" {
    type = map(string)
  
}

variable "instance_profile_name" {
    type = string
}
variable "security_group_name" {
    type = string
  
}
variable "vpc_id" {
    type = string
  
}
variable "security_group_tag" {
    type = map(string)
  
}
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "launch_template_name" {
    type = string
  
}
variable "instance_type" {
    type = string
  
}
variable "ami" {
    type = string
  
}
variable "user_data" {
    description = "User data script to be executed on instance launch"
    type = string
    default = ""
  
}
variable "key_name" {
    type = string  
}
variable "additional_ebs_block_devices" {
  description = "EBS block device configurations for additional volumes"
  type = list(object({
    device_name           = string  # The device name (e.g., /dev/xvdb)
    volume_size           = number  # Size of the volume in GB
    volume_type           = string  # Type of the volume (e.g., gp3, io1, etc.)
    delete_on_termination = bool    # Whether to delete the volume on instance termination
    iops                  = optional(number) # Provisioned IOPS for io1 or io2
    throughput            = optional(number) # Throughput for gp3
    encrypted             = optional(bool)   # Whether the volume is encrypted
    tags                  = optional(map(string)) # Tags for the volume
  }))
  default = []
}
variable "use_spot_instances" {
  description = "Whether to use Spot Instances"
  type        = bool
  default     = false
}

variable "spot_max_price" {
  description = "Maximum price for Spot Instances"
  type        = string
  default     = "0.05" # Adjust according to your workload and region
}


variable "launch_template_tags" {
    type = map(string)
  
}
variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "public_subnet_ids" {
    description = "List of IDs of the public subnets where the instance host will be launched"
    type = list(string)
  
}
variable "desired_capacity" {
  type        = number
  default     = 1
  description = "The desired capacity for the Auto Scaling group"
}

variable "max_size" {
  type        = number
  default     = 1
  description = "The maximum size for the Auto Scaling group"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "The minimum size for the Auto Scaling group"
}
variable "lifecycle_hook_script" {
  description = "Script to execute during lifecycle hook"
  type        = string
  default     = ""
}
variable "ebs_availability_zone" {
  type        = string
  description = "availability zone for EBS volume"
  default     = ""

}
variable "ebs_size" {
  type        = number
  description = "size of EBS volume"
  default     = 12
}
variable "ebs_name" {
  type = string
  default     = ""  
}
variable "ebs_type" {
  type        = string
  default     = "gp3"
  description = "Type of the EBS volume (e.g., gp3, io1, etc.)"
}
variable "ebs_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the EBS volume"
}
variable "create_ebs" {
  type        = bool
  default     = false
}
variable "create_eip" {
  type        = bool
  default     = false
  description = "Whether to create an Elastic IP and associate it with the instances"
}
variable "eip_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the Elastic IP"
}
