module "resource_group" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "storage_account" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_storage_account"
  stgs       = var.stgs
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_virtual_network"
  vnets      = var.vnets
}

module "public_ip" {
  depends_on = [module.virtual_network]
  source     = "../../modules/azurerm_public_ip"
  pips       = var.pips
}

# module "nsg" {
#   depends_on = [module.resource_group]
#   source     = "../../modules/azurerm_network_security_group"
#   nsgs       = var.nsgs
# }

module "nic" {
  depends_on = [module.resource_group, module.public_ip, module.virtual_network]
  source     = "../../modules/azurerm_network_interface"
  nics       = var.nics
}

# module "nic_nsg_association" {
#   depends_on          = [module.resource_group, module.nsg]
#   source              = "../../modules/azurerm_network_interface_security_group_association"
#   nic_nsg_association = var.nic_nsg_association
# }

module "vm" {
  depends_on = [module.resource_group, module.nic, module.key_vault, module.key_vault_secret]
  source     = "../../modules/azurerm_linux_virtual_machine"
  vms        = var.vms
}

module "key_vault" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_key_vaults"
  key_vaults = var.key_vaults
}

module "key_vault_secret" {
  depends_on = [module.key_vault]
  source     = "../../modules/azurerm_key_vault_secret"
  kv_secrets = var.kv_secrets
}

module "mssql_server" {
  source = "../../modules/azurerm_mssql_server"

  sql_servers = var.sql_servers
  depends_on  = [module.resource_group, module.key_vault_secret, module.key_vault]
}

module "mssql_database" {
  source = "../../modules/azurerm_mssql_database"

  sql_databases = var.sql_databases
  depends_on    = [module.mssql_server]
}