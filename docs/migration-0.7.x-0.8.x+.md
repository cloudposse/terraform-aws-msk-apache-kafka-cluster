# Migration from 0.7.x to 0.8.x

Version `0.8.0` of this module introduces breaking changes that, without taking additional precautions, will cause the MSK
cluster to be recreated.

This is because version `0.8.0` relies on the [terraform-aws-security-group](https://github.com/cloudposse/terraform-aws-security-group)
module for managing the broker security group. This changes the Terraform resource address for the Security Group, which will
[cause Terraform to recreate the SG](https://github.com/hashicorp/terraform-provider-aws/blob/3988f0c55ad6eb33c2b4c660312df9a4be4586b9/internal/service/kafka/cluster.go#L90-L97). 

To circumvent this, after bumping the module version to `0.8.0` (or above), run a plan to retrieve the resource addresses of
the SG that Terraform would like to destroy, and the resource address of the SG which Terraform would like to create.

First, make sure that the following variable is set:

```hcl
security_group_description = "Allow inbound traffic from Security Groups and CIDRs. Allow all outbound traffic"
```

Setting `security_group_description` to its "legacy" value will keep the Security Group from being replaced, and hence the MSK cluster.

Finally, change the resource address of the existing Security Group.

```bash
$ terraform state mv  "...aws_security_group.default[0]" "...module.broker_security_group.aws_security_group.default[0]" 
```

This will result in an apply that will only destroy SG Rules, but not the itself or the MSK cluster.
