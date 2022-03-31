resource "azurerm_resource_group" "terraform-rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_virtual_network" "terraform-vnet" {
  name                = var.virtual_network
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "terraform-subnet" {
  name                 = var.subnet
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.terraform-vnet.name
  resource_group_name  = azurerm_resource_group.terraform-rg.name
}

resource "azurerm_public_ip" "terraform-public-ip" {
  name                = var.terraform-public-ip
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "terraform-nsg" {
  name                = var.terraform-nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "terraform-ni" {
  name                = var.terraform-ni
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform-rg.name

  ip_configuration {
    name                          = "terraform-ip-configuration"
    subnet_id                     = azurerm_subnet.terraform-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraform-public-ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "terraform-nisg-association" {
  network_interface_id      = azurerm_network_interface.terraform-ni.id
  network_security_group_id = azurerm_network_security_group.terraform-nsg.id
}

resource "azurerm_storage_account" "terraform-storage-account" {
  name                     = "ywcdtzbfvpk"
  resource_group_name      = azurerm_resource_group.terraform-rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine" "terraform-vm" {
  name                            = var.terraform-vm
  resource_group_name             = azurerm_resource_group.terraform-rg.name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.terraform-ni.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.terraform-storage-account.primary_blob_endpoint
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
