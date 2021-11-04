package test

import (
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2018-06-01/compute"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../azure-hub",
		Vars: map[string]interface{}{
			"resource_group_name": "terratest",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	vmName := terraform.Output(t, terraformOptions, "vm_name")
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")

	// Look up the size of the given Virtual Machine
	actualVMSize := azure.GetSizeOfVirtualMachine(t, vmName, resourceGroupName, "")
	expectedVMSize := compute.VirtualMachineSizeTypes("Standard_B1s")

	// Test that the Virtual Machine size matches the Terraform specification
	assert.Equal(t, expectedVMSize, actualVMSize)
}
