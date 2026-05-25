variable "snowflake_account" {
  description = "Snowflake account identifier"
  type        = string
}

variable "snowflake_username" {
  description = "Snowflake username"
  type        = string
}

variable "snowflake_password" {
  description = "Snowflake password"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment"

  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "database_names" {
  description = "Snowflake databases"
  type        = list(string)

  default = [
    "streampulse_prod",
    "streampulse_staging"
  ]
}

variable "schema_names" {
  description = "Schemas to create in each database"
  type        = list(string)

  default = [
    "raw",
    "staging",
    "analytics",
    "marts"
  ]
}

variable "role_names" {
  description = "Application roles"
  type        = list(string)

  default = [
    "loader",
    "transformer",
    "analyst",
    "reporter",
    "developer",
    "data_admin"
  ]
}

variable "time_travel_retention_days" {
  description = "Time Travel retention period"
  type        = number
  default     = 7
}

variable "warehouses" {
  description = "Warehouse definitions"

  type = map(object({
    size           = string
    auto_suspend   = number
    monitor        = string
  }))
}

variable "resource_monitors" {
  description = "Resource monitor configuration"

  type = map(object({
    credit_quota = number
  }))
}