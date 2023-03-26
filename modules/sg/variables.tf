variable "sg_ingress" {
    type        = map(map(any))
    default     = {
        ingress1 = {from="9200", to="9200", protocol="tcp", cidr_block="0.0.0.0/0", description="ES-HTTP"}
        ingress2 = {from="9300", to="9300", protocol="tcp", cidr_block="0.0.0.0/0", description="ES-TCP"}
        ingress3 = {from="22", to="22", protocol="tcp", cidr_block="0.0.0.0/0", description="SSH"}
    }
} 
variable "id_vpc" {
}