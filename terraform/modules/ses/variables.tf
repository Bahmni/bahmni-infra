variable "domain_name" {
  type        = string
  description = "Domain Name for Amazon SES service"
}

variable "zone_id" {
  type        = string
  description = "Route 53 Hosted Zone ID for the domain_name"
}

variable "email_subdomain_name" {
  type        = string
  description = "Subdomain name for email"
}