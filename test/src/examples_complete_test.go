package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestExamplesComplete(t *testing.T) {
  terraformOptions := &terraform.Options{
    // The path to where our Terraform code is located
    TerraformDir: "../../examples/complete",
    Upgrade:      true,
    // Variables to pass to our Terraform code using -var-file options
    VarFiles: []string{"fixtures.us-east-2.tfvars"},
  }

  terraform.Init(t, terraformOptions)
  // Run tests in parallel
  t.Run("Disabled", testExamplesCompleteDisabled)
  t.Run("Enabled", testExamplesComplete)
}

// Test the Terraform module in examples/complete using Terratest.
func testExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
    EnvVars: map[string]string{
      "TF_CLI_ARGS": "-state=terraform-enabled.tfstate",
    },
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	outputClusterName := terraform.Output(t, terraformOptions, "cluster_name")

	// Verify we're getting back the outputs we expect
	assert.Regexp(t, "^eg-ue2-test-msk-test-[0-9a-fA-F]+$", outputClusterName)

	// Run `terraform output` to get the value of an output variable
	outputSecurityGroupName := terraform.Output(t, terraformOptions, "security_group_name")

	// Verify we're getting back the outputs we expect
	assert.Regexp(t, "^eg-ue2-test-msk-test-[0-9a-fA-F]+$", outputSecurityGroupName)
}

func testExamplesCompleteDisabled(t *testing.T) {
  t.Parallel()

  terraformOptions := &terraform.Options{
    // The path to where our Terraform code is located
    TerraformDir: "../../examples/complete",
    Upgrade:      true,
    EnvVars: map[string]string{
      "TF_CLI_ARGS": "-state=terraform-disabled-test.tfstate",
    },
    // Variables to pass to our Terraform code using -var-file options
    VarFiles: []string{"fixtures.us-east-2.tfvars"},
    Vars: map[string]interface{}{
      "enabled": false,
    },
  }

  // At the end of the test, run `terraform destroy` to clean up any resources that were created
  defer terraform.Destroy(t, terraformOptions)

  // This will run `terraform init` and `terraform apply` and fail the test if there are any errors
  terraform.Apply(t, terraformOptions)
}
