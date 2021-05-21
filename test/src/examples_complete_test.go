package test

import (
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())

	randId := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randId}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	outputClusterName := terraform.Output(t, terraformOptions, "cluster_name")

	// Verify we're getting back the outputs we expect
	assert.Regexp(t, "^eg-ue2-test-msk-test-[0-9a-fA-F]+$", outputClusterName)

	// Run `terraform output` to get the value of an output variable
	securityGroupName := terraform.Output(t, terraformOptions, "security_group_name")
	expectedSecurityGroupName := "eg-ue2-test-msk-test-" + randId
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedSecurityGroupName, securityGroupName)

	// Run `terraform output` to get the value of an output variable
	securityGroupID := terraform.Output(t, terraformOptions, "security_group_id")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, securityGroupID, "sg-", "SG ID should contains substring 'sg-'")

	// Run `terraform output` to get the value of an output variable
	securityGroupARN := terraform.Output(t, terraformOptions, "security_group_arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, securityGroupARN, "arn:aws:ec2", "SG ID should contains substring 'arn:aws:ec2'")
}
