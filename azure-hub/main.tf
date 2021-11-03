locals {
  region          = "EastUS2"
  environment_tag = "Dev"
}


module "network_hub" {
  source                  = "github.com/teokyllc/terraform-azure-network-hub"
  environment_tag         = local.environment_tag
  region                  = local.region
  vnet_cidr               = "10.0.0.0/16"
  default_subnet          = "10.0.0.0/24"
  gateway_subnet          = "10.0.255.0/24"
  dns_servers             = ["192.168.3.2"]
  ptp_vpn_remote_gw_name  = "home"
  ptp_vpn_remote_endpoint = "gate.teokyllc.org"
  ptp_vpn_psk             = var.ptp_vpn_psk
}

resource "azurerm_network_interface" "main" {
  name                = "test-vm-nic"
  location            = local.region
  resource_group_name = module.network_hub.network_rg_name

  ip_configuration {
    name                          = "terratestconfiguration1"
    subnet_id                     = module.network_hub.default_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                              = "test-vm"
  location                          = local.region
  resource_group_name               = module.network_hub.network_rg_name
  network_interface_ids             = ["${azurerm_network_interface.main.id}"]
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