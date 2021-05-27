terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

# fetched the docker image from the docker hub
resource "docker_image" "sqlserver" {
  name         = "mcr.microsoft.com/mssql/server:2019-latest"
  keep_locally = false
}

# Creates the SQL Server Storage Volume
resource "docker_volume" "sqlserverstorage" {
  name = "sqlServerStorage"
}

# Creates the container and runs it with the given parameters
resource "docker_container" "sqlserver" {
  image = docker_image.sqlserver.latest
  name  = "DevOpsServer"
  ports {
    internal = 1433
    external = 1433
  }
  env = ["ACCEPT_EULA=Y", "SA_PASSWORD=test123!"]
  mounts {
    type   = "volume"
    source = "sqlServerStorage"
    target = "/var/opt/mssql"
  }
}