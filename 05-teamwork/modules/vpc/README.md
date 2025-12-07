## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bridge"></a> [bridge](#input\_bridge) | Proxmox network bridge | `string` | `"vmbr0"` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR block for subnet | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name (develop, stage, prod) | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Network zone identifier | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_bridge"></a> [network\_bridge](#output\_network\_bridge) | Network bridge |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Network name |
| <a name="output_subnet_cidr"></a> [subnet\_cidr](#output\_subnet\_cidr) | Subnet CIDR |
| <a name="output_subnet_info"></a> [subnet\_info](#output\_subnet\_info) | Complete subnet information |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Subnet name |
| <a name="output_subnet_zone"></a> [subnet\_zone](#output\_subnet\_zone) | Subnet zone |
