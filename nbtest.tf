# Configure the Microsoft Azure Provider
provider "azurerm" {

  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}

resource "azurerm_resource_group" "nbtest" {
  name     = "nbtestrg"
  location = "North Europe"
}

resource "azurerm_virtual_network" "nbtest" {
  name                = "nbtestvn"
  address_space       = ["10.0.0.0/16"]
  location = "North Europe"
  resource_group_name = "${azurerm_resource_group.nbtest.name}"
}

resource "azurerm_subnet" "nbtest" {
  name                 = "nbtestsub"
  resource_group_name  = "${azurerm_resource_group.nbtest.name}"
  virtual_network_name = "${azurerm_virtual_network.nbtest.name}"
  address_prefix       = "10.0.2.0/24"
}


resource "azurerm_storage_account" "nbtest" {
  name                = "nbdisksa"
  resource_group_name = "${azurerm_resource_group.nbtest.name}"
  location              = "North Europe"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "nbtest" {
  name                  = "nbvhds"
  resource_group_name   = "${azurerm_resource_group.nbtest.name}"
  storage_account_name  = "${azurerm_storage_account.nbtest.name}"
  container_access_type = "private"
}


resource "azurerm_public_ip" "nbtest" {
  name                         = "nbtestIP"
  location            = "North Europe"
  resource_group_name          = "${azurerm_resource_group.nbtest.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_network_interface" "nbtest" {
  name                = "nbtestni"
  location            = "North Europe"
  resource_group_name = "${azurerm_resource_group.nbtest.name}"

  ip_configuration {
    name                          = "nbtestconfiguration1"
    subnet_id                     = "${azurerm_subnet.nbtest.id}"
    private_ip_address_allocation = "dynamic"
  public_ip_address_id = "${azurerm_public_ip.nbtest.id}"
  }
}

resource "azurerm_virtual_machine" "nbtest" {
  name                  = "nbtestvm"
  location              = "North Europe"
  resource_group_name   = "${azurerm_resource_group.nbtest.name}"
  network_interface_ids = ["${azurerm_network_interface.nbtest.id}"]
  vm_size               = "Basic_A1"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.2-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "myosdisk1"
    vhd_uri       = "${azurerm_storage_account.nbtest.primary_blob_endpoint}${azurerm_storage_container.nbtest.name}/nbosdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

   os_profile {
    computer_name  = "nbtest"
    admin_username = "${var.username}"
    admin_password = "${var.pass}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

