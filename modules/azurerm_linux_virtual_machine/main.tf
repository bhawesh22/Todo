
resource "azurerm_linux_virtual_machine" "vm" {
    for_each = var.vms
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = data.azurerm_key_vault_secret.vm_admin_username[each.key].value
  admin_password      = data.azurerm_key_vault_secret.vm_admin_password[each.key].value
  disable_password_authentication = each.value.disable_password_authentication
  network_interface_ids = [data.azurerm_network_interface.nic_ids[each.key].id]

#   dynamic "admin_ssh_key" {
#     for_each = each.value.admin_ssh_key
#     content {
#             username  = admin_ssh_key.value.username
#             public_key =    admin_ssh_key.value.public_key
#     }
#   }
  
  


   dynamic "os_disk" {
    for_each = each.value.os_disk
    content {
    name                 = os_disk.value.name
    caching              = os_disk.value.caching
    storage_account_type = os_disk.value.storage_account_type
    disk_size_gb         = os_disk.value.disk_size_gb
    }
   }
   


source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }
}