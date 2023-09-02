#maser vm ip address
output "ip_address_master_vm" {
  value = azurerm_public_ip.master-ip.ip_address
}