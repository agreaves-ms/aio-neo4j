resource "azapi_resource" "aio_targets_neo4j_pv" {
  count     = var.should_install_neo4j_pvc ? 1 : 0
  type      = "Microsoft.IoTOperationsOrchestrator/Targets@2023-10-04-preview"
  name      = "neo4j-pvc"
  location  = data.azurerm_resource_group.this.location
  parent_id = data.azurerm_resource_group.this.id

  body = jsonencode({
    extendedLocation = {
      name = local.custom_locations_id
      type = "CustomLocation"
    }

    properties = {
      scope   = var.aio_cluster_namespace
      version = var.neo4j_target_version
      components = [
        {
          name = "neo4j-pvc"
          type = "yaml.k8s"
          properties = {
            resource = yamldecode(templatefile("./manifests/neo4j-pvc.yaml", {
              neo4j_pvc_name     = var.neo4j_pvc_name
              neo4j_storage_size = var.neo4j_storage_size
            }))
          }
        },
      ]

      topologies = [
        {
          bindings = [
            {
              role     = "yaml.k8s"
              provider = "providers.target.kubectl"
              config = {
                inCluster = "true"
              }
            }
          ]
        }
      ]
    }
  })
}

resource "azapi_resource" "aio_targets_neo4j" {
  schema_validation_enabled = false
  type                      = "Microsoft.IoTOperationsOrchestrator/Targets@2023-10-04-preview"
  name                      = "neo4j"
  location                  = data.azurerm_resource_group.this.location
  parent_id                 = data.azurerm_resource_group.this.id

  depends_on = [azapi_resource.aio_targets_neo4j_pv]

  body = jsonencode({
    extendedLocation = {
      name = local.custom_locations_id
      type = "CustomLocation"
    }

    properties = {
      scope   = var.aio_cluster_namespace
      version = var.neo4j_target_version
      components = [
        {
          name = "neo4j"
          type = "helm.v3"
          properties = {
            chart = {
              repo = "https://helm.neo4j.com/neo4j"
              name = "neo4j"
            }
            values = yamldecode(
              templatefile("./config/neo4j-values.yaml", {
                neo4j_name     = var.neo4j_name
                neo4j_pvc_name = var.neo4j_pvc_name
              })
            )
          }
        },
      ]

      topologies = [
        {
          bindings = [
            {
              role     = "helm.v3"
              provider = "providers.target.helm"
              config = {
                inCluster = "true"
              }
            },
          ]
        }
      ]
    }
  })
}