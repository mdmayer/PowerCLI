##########Query VMs for hw version 8, set task to automatically update hw to version 9 at reboot###########
##################################Written by Mark Mayer October 21st 2014##################################




$vms = Get-VM -Name * | where { $_.version -eq 'v8'}
$vc = Read-Host "Enter the VC name"
$cred = Get-Credential

Connect-VIServer $vc -Credential $cred

foreach($vm in $vms)
{

Get-VM -Name $vm
$vmConfigSpec = New-Object -TypeName VMware.Vim.VirtualMachineConfigSpec
$vmConfigSpec.ScheduledHardwareUpgradeInfo = New-Object -TypeName VMware.Vim.ScheduledHardwareUpgradeInfo
$vmConfigSpec.ScheduledHardwareUpgradeInfo.UpgradePolicy = "always"
$vmConfigSpec.ScheduledHardwareUpgradeInfo.VersionKey = "vmx-09"
$vm.ExtensionData.ReconfigVM_Task($vmConfigSpec)
Write-Host "$vmConfigSpec"
Write-Host "$VM hardware task set up"

}

Disconnect-VIServer -Confirm:$false
