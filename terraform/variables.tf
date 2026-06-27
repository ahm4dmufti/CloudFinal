variable "subscription_id" {
  description = "Your Azure Subscription ID"
  type        = string
}

variable "student_name" {
  description = "Full name — used in the StudentName tag"
  type        = string
  default     = "Ahmad El-Mufti"
}

variable "name_prefix" {
  description = "Lowercase, no-spaces prefix used inside resource names"
  type        = string
  default     = "ahmad"
}

variable "location" {
  type    = string
  default = "switzerlandnorth"
}

variable "acr_name" {
  description = "MUST be globally unique, 5-50 lowercase letters/numbers"
  type        = string
  default     = "cloudscaleahmadacr"
}
