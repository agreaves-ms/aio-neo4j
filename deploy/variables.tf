variable "name" {
  description = "The unique primary name used when naming resources. (ex. 'test' makes 'rg-test' resource group)"
  type        = string
  nullable    = false
  validation {
    condition     = var.name != "sample-aio" && length(var.name) < 15 && can(regex("^[a-z0-9][a-z0-9-]{1,60}[a-z0-9]$", var.name))
    error_message = "Please update 'name' to a short, unique name, that only has lowercase letters, numbers, '-' hyphens."
  }
}

variable "arc_cluster_name" {
  description = "(Optional) the Arc Cluster resource name. (Otherwise, 'arc-<var.name>')"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "(Optional) The resource group name where the Azure Arc Cluster resource is located. (Otherwise, 'rg-<var.name>')"
  type        = string
  default     = null
}

variable "aio_cluster_namespace" {
  description = "(Optional) The namespace in the cluster where AIO resources will be deployed."
  type        = string
  default     = "azure-iot-operations"
}

variable "custom_locations_name" {
  description = "(Optional) The Custom Locations resource name. (Otherwise, 'cl-<var.name>-aio')"
  type        = string
  default     = null
}

variable "neo4j_target_version" {
  description = "(Optional) The Targets version for neo4j. (Otherwise, '1.0.0')"
  type        = string
  default     = "1.0.0"
}

variable "should_install_neo4j_pvc" {
  description = "(Optional) Installs a Persistent Volume Claim for a `local-path` StorageClass if one does not exist. (Otherwise, 'true')"
  type        = bool
  default     = true
}

variable "neo4j_name" {
  description = "(Optional) The name of Neo4j in the cluster. (Otherwise, 'neo4j-db')"
  type        = string
  default     = "neo4j-db"
}

variable "neo4j_storage_size" {
  description = "(Optional) The storage size for the Neo4j Persistent Volume. (Otherwise, '8Gi')"
  type        = string
  default     = "8Gi"
}

variable "neo4j_pvc_name" {
  description = "(Optional) The name of the Neo4j Persistent Volume Claim that will be used by Neo4j. (Otherwise, 'neo4j-pvc')"
  type        = string
  default     = "neo4j-pvc"
}
