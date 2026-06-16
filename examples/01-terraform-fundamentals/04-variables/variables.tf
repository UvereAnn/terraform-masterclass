variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "owner" {
  description = "Infrastructure owner"
  type        = string
}

variable "devops_engineer_id" {
  description = "The id of the devops engineer in charge"
  type        = number
}

variable "devops_engineer_name" {
  description = "The name of the devops engineer in charge"
  type        = string
}