rgs = {
  rg1 = {
    name       = "rg-bhawesh-dev"
    location   = "Central India"
    managed_by = "terraform"
    tags = {
      env = "dev"
    }
  }

  rg2 = {
    name       = "bhawesh"
    location   = "East US"
    managed_by = "self"
    tags = {
      env = "prod"
    }
  }

}

stgs = {

  stg1 = {
    name                     = "bhaweshstorage"
    resource_group_name      = "rg-bhawesh-dev"
    location                 = "Central India"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags = {

      environment = "DEV"
      project     = "Self Company"
      owner       = "Bhawesh Mishra"
      cost        = "$500"

    }
  }
}

vnets = {

  vnet1 = {
    name                = "VNET-TODO-INFRA"
    location            = "Central India"
    resource_group_name = "rg-bhawesh-dev"
    address_space       = ["10.0.0.0/16"]
    tags = {
environment = "DEV"
      project     = "Self Company"
      owner       = "Bhawesh Mishra"
      cost        = "$500"

    }
    subnets = [
      {
        name             = "frontend-subnet"
        address_prefixes = ["10.0.1.0/24"]
      },
      {
        name             = "backend-subnet"
        address_prefixes = ["10.0.2.0/24"]
      }
    ]

  }
}


pips = {

  pip1 = {
    name                = "pip-frontend1"
    resource_group_name = "rg-bhawesh-dev"
    location            = "Central India"
    allocation_method   = "Static"
    tags = {
environment = "DEV"
      project     = "Self Company"
      owner       = "Bhawesh Mishra"
      cost        = "$500"
      
    }
  }

  pip2 = {
    name                = "pip-backend1"
    resource_group_name = "rg-bhawesh-dev"
    location            = "Central India"
    allocation_method   = "Static"
    tags = {
      environment = "DEV"
      project     = "Self Company"
      owner       = "Bhawesh Mishra"
      cost        = "$500"

    }
  }
}


# nsgs = {

#   nsg1 = {
#     name                = "frontend-nsg"
#     location            = "Central India"
#     resource_group_name = "rg-bhawesh-dev"
#     tags = {
#       environment = "DEV"
#     }
#     security_rules = [{
#       name                       = "SSH"
#       priority                   = 1001
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "22"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#       },
#       {
#         name                       = "HTTP"
#         priority                   = 1002
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "Tcp"
#         source_port_range          = "*"
#         destination_port_range     = "80"
#         source_address_prefix      = "*"
#         destination_address_prefix = "*"
#     }]
#   }

#   nsg2 = {
#     name                = "backend-nsg"
#     location            = "Central India"
#     resource_group_name = "rg-bhawesh-dev"
#     tags = {
#       environment = "DEV"
#     }
#     security_rules = [
#       {
#         name                       = "HTTP"
#         priority                   = 1003
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "Tcp"
#         source_port_range          = "*"
#         destination_port_range     = "80"
#         source_address_prefix      = "*"
#         destination_address_prefix = "*"
#       }
#     ]
#   }
# }

nics = {

  nic1 = {

    vnet_name   = "VNET-TODO-INFRA"
    subnet_name = "frontend-subnet"
    pip_name    = "pip-frontend1"
    # resource block variable
    name                           = "nic-frontend"
    resource_group_name            = "rg-bhawesh-dev"
    location                       = "Central India"
    ip_forwarding_enabled          = "false"
    accelerated_networking_enabled = "false"
    tags = {
      environment = "dev"
    }
    ip_configurations = [
      {
        name                          = "ipconfig1"
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version    = "IPv4"
        primary                       = true
      }
    ]



  }

  nic2 = {

    vnet_name   = "VNET-TODO-INFRA"
    subnet_name = "backend-subnet"
    pip_name    = "pip-backend1"
    # resource block variable
    name                           = "nic-backend"
    resource_group_name            = "rg-bhawesh-dev"
    location                       = "Central India"
    ip_forwarding_enabled          = "false"
    accelerated_networking_enabled = "false"
    tags = {
      environment = "dev"
    }
    ip_configurations = [
      {
        name                          = "ipconfig2"
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version    = "IPv4"
        primary                       = true
      }
    ]



  }
}

# nic_nsg_association = {
#   assoc1 = {
#     nic_name            = "nic-frontend"
#     nsg_name            = "frontend-nsg"
#     resource_group_name = "rg-bhawesh-dev"
#   }
#   assoc2 = {
#     nic_name            = "nic-backend"
#     nsg_name            = "backend-nsg"
#     resource_group_name = "rg-bhawesh-dev"
#   }
# }

vms = {

  vm1 = {
    name                            = "vm-todo-frontend1"
    location                        = "Central India"
    resource_group_name             = "rg-bhawesh-dev"
    size                            = "Standard_D2s_v3"
    disable_password_authentication = false
    nic_name                        = "nic-frontend"
    kv_name                         = "kv-todo-appbm"
    vm_username_secret_name         = "vm-adminusername"
    vm_password_secret_name         = "vm-adminpassword"
    provision_vm_agent              = true
    script_name                     = "middleware_nginx.sh"
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }

    os_disk = [
      {
        name                 = "vm-todo-frontend-osdisk"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb         = 30
      }
    ]

    admin_ssh_key    = []
    boot_diagnostics = []
    tags = {
      environment = "dev"
    }

  }

  vms2 = {
    name                            = "vm-todo-backend11"
    location                        = "Central India"
    resource_group_name             = "rg-bhawesh-dev"
    size                            = "Standard_D2s_v3"
    disable_password_authentication = false
    nic_name                        = "nic-backend"
    kv_name                         = "kv-todo-appbm"
    vm_username_secret_name         = "vm-adminusername"
    vm_password_secret_name         = "vm-adminpassword"
    provision_vm_agent              = true
    script_name                     = "middleware_nginx.sh"

    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }

    os_disk = [{
      name                 = "vm-todo-backend-osdisk"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 30
    }]

    admin_ssh_key    = []
    boot_diagnostics = []
    tags = {
      environment = "dev"
    }

  }
}

key_vaults = {
  kv-devjp = {
    name                            = "kv-todo-appbm"
    resource_group_name             = "rg-bhawesh-dev"
    location                        = "Central India"
    sku_name                        = "standard"
    enabled_for_deployment          = true
    enabled_for_disk_encryption     = true
    enabled_for_template_deployment = false
    purge_protection_enabled        = true
    soft_delete_retention_days      = 7

    access_policies = [
      {

        key_permissions         = ["Get", "List", "Create", "Delete"]
        secret_permissions      = ["Get", "List", "Set", "Delete", "Recover"]
        certificate_permissions = ["Get", "List", "Create"]
        storage_permissions     = ["Get", "List"]
      }
    ]

    tags = {
      environment = "dev"
      owner       = "bhawesh mishra1"
      project     = "terraform-modular-bhawesh"
      costcenter  = "cc001"
    }
  }

}


kv_secrets = {
  secret1 = {
    kv_name      = "kv-todo-appbm"
    rg_name      = "rg-bhawesh-dev"
    secret_name  = "vm-adminusername"
    secret_value = "azureuser"

  },
  secret2 = {
    kv_name      = "kv-todo-appbm"
    rg_name      = "rg-bhawesh-dev"
    secret_name  = "vm-adminpassword"
    secret_value = "P@ssword123!"
  },
  secret3 = {
    kv_name      = "kv-todo-appbm"
    rg_name      = "rg-bhawesh-dev"
    secret_name  = "sql-adminusername"
    secret_value = "sqladmintodo"
  },
  secret4 = {
    kv_name      = "kv-todo-appbm"
    rg_name      = "rg-bhawesh-dev"
    secret_name  = "sql-adminpassword"
    secret_value = "P@ssword123!"
  }
}

sql_servers = {
  sql1 = {
    name                                     = "bhaweshapp-dev-db-server"
    resource_group_name                      = "rg-bhawesh-dev"
    location                                 = "Central India"
    version                                  = "12.0"
    kv_name                                  = "kv-todo-appbm"
    sql_username_secret_name                 = "sql-adminusername"
    sql_password_secret_name                 = "sql-adminpassword"
    connection_policy                        = "Default"
    express_vulnerability_assessment_enabled = true
    minimum_tls_version                      = "1.2"
    public_network_access_enabled            = true
    outbound_network_restriction_enabled     = false

    identity = [
      {
        type         = "SystemAssigned"
        identity_ids = []
      }
    ]

    tags = {
      project     = "ANANYA-NETWORK"
      environment = "dev"
      managed_by  = "terraform"
    }
  }
}

sql_databases = {
  sql_db1 = {
    name                = "todo-databasebm"
    server_name         = "bhaweshapp-dev-db-server"
    resource_group_name = "rg-bhawesh-dev"
    location            = "Central India"
    sku_name            = "S0"
    max_size_gb         = 10
    read_scale          = false
    zone_redundant      = false
    collation           = "SQL_Latin1_General_CP1_CI_AS"
    create_mode         = "Default"

    tags = {
      project     = "ANANYA-NETWORK"
      environment = "dev"
      managed_by  = "terraform"

    }
  }
}

