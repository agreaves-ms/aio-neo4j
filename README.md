# Azure IoT Operations Neo4j

Neo4j deployed onto Azure IoT Operations (AIO) using Terraform.

## Getting Started

### Prerequisites

- (Optionally for Windows) [WSL](https://learn.microsoft.com/windows/wsl/install) installed and setup.
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) available on the command line where this will be deployed.
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) available on the command line where this will be deployed.
- Cluster with Azure IoT Operations deployed -> This project assumes [azure-edge-extensions-aio-iac-terraform](https://github.com/Azure-Samples/azure-edge-extensions-aio-iac-terraform) was used, however, any cluster with AIO deployed will work.
- Owner access to a Resource Group with an existing cluster configured and connected to Azure Arc.

### Quickstart

1. Login to the AZ CLI:
    ```shell
    az login --tenant <tenant>.onmicrosoft.com
    ```
    - Make sure your subscription is the one that you would like to use: `az account show`.
    - Change to the subscription that you would like to use if needed:
      ```shell
      az account set -s <subscription-id>
      ```
2. Add a `<unique-name>.auto.tfvars` file to the root of the [deploy](deploy) directory that contains the following:
    ```hcl
    // <project-root>/deploy/<unique-name>.auto.tfvars

    name = "<unique-name>"
    ```
3. From the [deploy](deploy) directory execute the following:
   ```shell
   terraform init
   terraform apply
   ```

## Usage

After the Terraform in this project has been applied, you should be able to connect to your cluster using the `az connectedk8s proxy` command:

```shell
az connectedk8s proxy -g rg-<unique-name> -n arc-<unique-name>
```

Copy out the `neo4j-db-auth` secret to get the username and password for the newly deploy Neo4j.

```shell
kubectl get secret neo4j-db-auth --namespace azure-iot-operations -o jsonpath="{.data.NEO4J_AUTH}" | base64 --decode
# The value will be in the format <username>/<password>
```

Setup port forwarding in two consoles for the Neo4j admin service ports to allow access to the Neo4j dashboard from your local browser.

```shell
# First console

kubectl port-forward service/neo4j-admin 7474:7474 -n azure-iot-operations
```

```shell
# Second console

kubectl port-forward service/neo4j-admin 7687:7687 -n azure-iot-operations
```

Open your browser and navigate to [http://localhost:7474/browser](http://localhost:7474/browser). Enter in the `username` and `password` from the earlier step.
