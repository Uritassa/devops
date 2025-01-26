variable "create_policy" {
  description = "Whether to create the IAM policy"
  type        = bool
  default     = true
}

variable "create_role" {
  description = "Whether to create the IAM role"
  type        = bool
  default     = true
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "Description of the IAM policy"
  type        = string
  default     = null
}

variable "policy_document" {
  description = "JSON-formatted policy document"
  type        = string
  default     = null
}

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = null
}

variable "role_tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}
variable "policy_tags" {
  description = "Tags to apply to the IAM policy"
  type        = map(string)
  default     = {}
}

variable "assume_role_policy" {
  description = "The policy that grants an entity permission to assume the role."
  type        = string
  default     = null
}