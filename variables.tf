variable "subscription_id" {
    type = string
    description = "The Azure subscription id."
}

variable "aad_tenant_id" {
    type = string
    description = "The Azure AD tenant id."
}

variable "client_id" {
    type = string
    description = "The Azure service principal client id."
}

variable "client_secret" {
    type = string
    description = "The Azure service principal client secret."
}

variable "ptp_vpn_psk" {
    type = string
    description = "The VPN PSK."
}