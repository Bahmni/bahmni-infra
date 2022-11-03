variable "domain_name" {
  type        = string
  description = "Domain Name for Amazon SES service"
}

variable "zone_id" {
  type        = string
  description = "Route 53 Hosted Zone ID for the domain_name"
}

variable "ses_domain_identity_arn" {
  type        = string
  description = "SES Domian Identity ARN"
  sensitive   = true
}
