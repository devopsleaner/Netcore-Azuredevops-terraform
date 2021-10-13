provider "azurerm" {
    version = "2.5.0"
    features {}
}


terraform {
  backend "azurerm" {
    resource_group_name = "tf_rg_blobstore"
    storage_account_name = "tfstoragedevopsleaner"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
  
}
variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}



resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "ukwest"
}

resource "azurerm_container_group" "tfcg_test" {
    name                = "azure-devops-api"
    location            =  azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type     = "public"
    dns_name_label      = "devopsleanerazuredevopsapi"
    os_type             = "Linux"

    container {
        name    = "netcoreazuredevops"
        image   = "devopsleaner/netcoreazuredevops::${var.imagebuild}"
        cpu = "1"
        memory = "1"

        ports {
            port = 80
            protocol = "TCP"
        }
    }
}