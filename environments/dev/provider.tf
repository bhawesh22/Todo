terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.54.0"
    }
  }
  backend "azurerm" {}

}



provider "azurerm" {
  features {}
  subscription_id = "18bbb1ca-f79e-49b4-8669-5a1208da00f7"
}

