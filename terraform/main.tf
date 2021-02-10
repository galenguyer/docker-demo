# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  subscription_id = "a779aaef-4693-4c3a-bf68-6aa99ffe1acf"
  features {}
}

resource "azurerm_resource_group" "docker-demo" {
  name     = "docker-demo"
  location = "East US 2"
}

resource "azurerm_virtual_network" "docker-demo-vnet" {
 name                = "docker-demo-vnet"
 address_space       = ["10.0.0.0/16"]
 location            = "East US 2"
 resource_group_name = azurerm_resource_group.docker-demo.name
}

resource "azurerm_subnet" "docker-demo-subnet" {
 name                 = "docker-demo-subnet"
 resource_group_name  = azurerm_resource_group.cdn.name
 virtual_network_name = azurerm_virtual_network.docker-demo-vnet.name
 address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "docker-demo-ip" {
 name                         = "docker-demo-ip"
 location                     = "East US 2"
 resource_group_name          = azurerm_resource_group.docker-demo.name
 allocation_method            = "Static"
 domain_name_label            = "docker-demo"
}

resource "azurerm_network_security_group" "docker-demo-nsg" {
    name                = "docker-demo-nsg"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.cdn.name

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
    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTPS"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "docker-demo-nic" {
    name                        = "docker-demo-nic"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.cdn.name

    ip_configuration {
        name                          = "docker-demo-nic-config"
        subnet_id                     = azurerm_subnet.docker-demo-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.docker-demo-ip.id
    }
}

resource "azurerm_network_interface_security_group_association" "docker-demo-nic-nsg-association" {
    network_interface_id      = azurerm_network_interface.docker-demo-nic.id
    network_security_group_id = azurerm_network_security_group.docker-demo-nsg.id
}

resource "azurerm_linux_virtual_machine" "docker-demo" {
    name                  = "docker-demo"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.cdn.name
    network_interface_ids = [azurerm_network_interface.docker-demo-nic.id]
    size                  = "Standard_B1ls"

    os_disk {
        name                 = "docker-demo-osdisk"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Debian"
        offer     = "debian-10"
        sku       = "10"
        version   = "latest"
    }

    admin_username = "chef"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "chef"
        public_key = file("~/.ssh/id_rsa.pub")
    }
}
