locals {
  region          = "EastUS2"
  environment_tag = "Dev"
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = local.region
}

resource "azurerm_virtual_network" "main" {
  name                = "terratest-network"
  address_space       = ["10.0.0.0/16"]
  location            = local.region
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.17.0/24"
}

resource "azurerm_network_interface" "main" {
  name                = "terratest-nic"
  location            = local.region
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "terratestconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                              = "test-vm"
  location                          = local.region
  resource_group_name               = azurerm_resource_group.main.name
  network_interface_ids             = [azurerm_network_interface.main.id]
  vm_size                           = "Standard_B1s"
  delete_os_disk_on_termination     = true
  delete_data_disks_on_termination  = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "terratestosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "test-vm"
    admin_username = "allan"
    admin_password = "1!1kBFFvkOR2wrkG"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
