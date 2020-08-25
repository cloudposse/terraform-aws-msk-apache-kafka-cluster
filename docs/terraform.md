## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, < 0.14.0 |
| aws | ~> 3.0 |
| local | ~> 1.2 |
| random | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| random | ~> 2.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_cidr\_blocks | List of CIDR blocks to be allowed to connect to the cluster | `list(string)` | `[]` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| broker\_instance\_type | Specify the instance type to use for the kafka brokers | `string` | n/a | yes |
| broker\_volume\_size | The size in GiB of the EBS volume for the data drive on each broker node | `number` | `1000` | no |
| certificate\_authority\_arns | List of ACM Certificate Authority Amazon Resource Names (ARNs) | `list(string)` | `[]` | no |
| client\_broker | Encryption setting for data in transit between clients and brokers | `string` | `"TLS"` | no |
| cloudwatch\_logs\_enabled | Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs | `bool` | `false` | no |
| cloudwatch\_logs\_log\_group | Name of the Cloudwatch Log Group to deliver logs to | `string` | `""` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| encryption\_at\_rest\_kms\_key\_arn | You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest | `string` | `""` | no |
| encryption\_in\_cluster | Whether data communication among broker nodes is encrypted | `bool` | `true` | no |
| enhanced\_monitoring | Specify the desired enhanced MSK CloudWatch monitoring level | `string` | `"DEFAULT"` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| firehose\_delivery\_stream | Name of the Kinesis Data Firehose delivery stream to deliver logs to | `string` | `""` | no |
| firehose\_logs\_enabled | Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose | `bool` | `false` | no |
| jmx\_exporter\_enabled | Indicates whether you want to enable or disable the JMX Exporter | `bool` | `false` | no |
| kafka\_version | Specify the desired Kafka software version | `string` | n/a | yes |
| label\_order | The naming order of the id output and Name tag | `list(string)` | `[]` | no |
| name | Solution name, e.g. 'app' or 'cluster' | `string` | `""` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| node\_exporter\_enabled | Indicates whether you want to enable or disable the Node Exporter | `bool` | `false` | no |
| number\_of\_broker\_nodes | The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets. It must be a multiple of the number of specified client subnets. | `number` | n/a | yes |
| s3\_logs\_bucket | Name of the S3 bucket to deliver logs to | `string` | `""` | no |
| s3\_logs\_enabled | Indicates whether you want to enable or disable streaming broker logs to S3 | `bool` | `false` | no |
| s3\_logs\_prefix | Prefix to append to the folder name | `string` | `""` | no |
| security\_groups | List of security group IDs to be allowed to connect to the cluster | `list(string)` | `[]` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `""` | no |
| subnet\_ids | Subnet IDs | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| vpc\_id | VPC ID where subnets will be created (e.g. `vpc-aceb2723`) | `string` | n/a | yes |
| zone\_id | Route53 DNS Zone ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bootstrap\_broker\_tls | A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster |
| bootstrap\_brokers | A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster |
| cluster\_arn | Amazon Resource Name (ARN) of the MSK cluster |
| config\_arn | Amazon Resource Name (ARN) of the configuration |
| current\_version | Current version of the MSK Cluster used for updates |
| hostname | DNS hostname |
| latest\_revision | Latest revision of the configuration |
| security\_group\_id | The ID of the security group rule |
| zookeeper\_connect\_string | A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster |

