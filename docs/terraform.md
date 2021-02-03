<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2.0 |
| local | >= 1.2 |
| random | >= 2.2 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| allowed\_cidr\_blocks | List of CIDR blocks to be allowed to connect to the cluster | `list(string)` | `[]` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| broker\_instance\_type | The instance type to use for the Kafka brokers | `string` | n/a | yes |
| broker\_volume\_size | The size in GiB of the EBS volume for the data drive on each broker node | `number` | `1000` | no |
| certificate\_authority\_arns | List of ACM Certificate Authority Amazon Resource Names (ARNs) to be used for TLS client authentication | `list(string)` | `[]` | no |
| client\_broker | Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT` | `string` | `"TLS"` | no |
| client\_sasl\_scram\_enabled | Enables SCRAM client authentication via AWS Secrets Manager. | `bool` | `false` | no |
| client\_sasl\_scram\_secret\_association\_arns | List of AWS Secrets Manager secret ARNs for scram authentication. | `list(string)` | `[]` | no |
| client\_tls\_auth\_enabled | Set `true` to enable the Client TLS Authentication | `bool` | `false` | no |
| cloudwatch\_logs\_enabled | Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs | `bool` | `false` | no |
| cloudwatch\_logs\_log\_group | Name of the Cloudwatch Log Group to deliver logs to | `string` | `null` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>    label_key_case      = string<br>    label_value_case    = string<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| encryption\_at\_rest\_kms\_key\_arn | You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest | `string` | `""` | no |
| encryption\_in\_cluster | Whether data communication among broker nodes is encrypted | `bool` | `true` | no |
| enhanced\_monitoring | Specify the desired enhanced MSK CloudWatch monitoring level. Valid values: `DEFAULT`, `PER_BROKER`, and `PER_TOPIC_PER_BROKER` | `string` | `"DEFAULT"` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| firehose\_delivery\_stream | Name of the Kinesis Data Firehose delivery stream to deliver logs to | `string` | `""` | no |
| firehose\_logs\_enabled | Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose | `bool` | `false` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| jmx\_exporter\_enabled | Set `true` to enable the JMX Exporter | `bool` | `false` | no |
| kafka\_version | The desired Kafka software version | `string` | n/a | yes |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`. <br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation). <br>Default value: `lower`. | `string` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| node\_exporter\_enabled | Set `true` to enable the Node Exporter | `bool` | `false` | no |
| number\_of\_broker\_nodes | The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets. | `number` | n/a | yes |
| properties | Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html) | `map(string)` | `{}` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| s3\_logs\_bucket | Name of the S3 bucket to deliver logs to | `string` | `""` | no |
| s3\_logs\_enabled | Indicates whether you want to enable or disable streaming broker logs to S3 | `bool` | `false` | no |
| s3\_logs\_prefix | Prefix to append to the S3 folder name logs are delivered to | `string` | `""` | no |
| security\_groups | List of security group IDs to be allowed to connect to the cluster | `list(string)` | `[]` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| subnet\_ids | Subnet IDs for Client Broker | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| vpc\_id | VPC ID where subnets will be created (e.g. `vpc-aceb2723`) | `string` | n/a | yes |
| zone\_id | Route53 DNS Zone ID for MSK broker hostnames | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bootstrap\_broker\_tls | A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster |
| bootstrap\_brokers | A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster |
| bootstrap\_brokers\_scram | A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity using SASL/SCRAM to the kafka cluster. |
| cluster\_arn | Amazon Resource Name (ARN) of the MSK cluster |
| cluster\_name | MSK Cluster name |
| config\_arn | Amazon Resource Name (ARN) of the configuration |
| current\_version | Current version of the MSK Cluster used for updates |
| hostname | MSK Cluster Broker DNS hostname |
| latest\_revision | Latest revision of the configuration |
| security\_group\_id | The ID of the security group rule |
| security\_group\_name | The name of the security group rule |
| zookeeper\_connect\_string | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster |

<!-- markdownlint-restore -->
