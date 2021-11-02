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
