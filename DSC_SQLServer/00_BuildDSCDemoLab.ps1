Import-Module AutomatedLab
#Here AL installs a lab with one domain controller and one client. The OS can be configured quite easily as well as
#the domain name or memory. AL takes care about network settings like in the previous samples.

New-LabDefinition -Name DscLab1 -DefaultVirtualizationEngine HyperV -VmPath C:\AutomatedLab-VMs\VMs

Add-LabVirtualNetworkDefinition -Name DscLab1
Add-LabVirtualNetworkDefinition -Name 'Default Switch' -HyperVProperties @{ SwitchType = 'External'; AdapterName = 'Wi-Fi' }

$netAdapter = @()
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch DscLab1
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch 'Default Switch' -UseDhcp


#defining default parameter values, as these ones are the same for all the machines
$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:DomainName'      = 'pomfret.com'
    'Add-LabMachineDefinition:Memory'          = 1GB
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2019 Datacenter (Desktop Experience)'
    'Add-LabMachineDefinition:Network'         = 'DscLab1'
}

Add-LabMachineDefinition -Name DC -Roles RootDC, Routing -NetworkAdapter $netAdapter -Memory 2GB
Add-LabMachineDefinition -Name DscSvr1
Add-LabMachineDefinition -Name DscSvr2

Install-Lab

Show-LabDeploymentSummary -Detailed

<#
- add the external network adapter to DC & reboot

-- install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

-- getting demo scripts
    -- install git
    -- install VSCode + PowerShell Extension
    -- install ADS
    choco install git
    choco install vscode
    choco install vscode-powershell
    choco install azure-data-studio

    --clone demo repo
    mkdir c:\github
    cd c:\github
    git clone https://github.com/jpomfret/demos.git


    mkdir C:\Share\DSCResources\LCM
    - share it and give permissions to dscsvr1, dscsvr2 computer accounts

    Save-Module SqlServerDsc, PSDscResources, SecurityPolicyDSC -Path c:\share\DscResources
    "`$env:PSModulePath += ';\\dc\share'" > $PROFILE.AllUsersAllHosts

    Put installation media out here
    mkdir C:\Share\Software\SQLServer
    -- put the source media here

    create your sa user
    new-aduser -Name jpomfret



    -- serverbuild
    File share for software & DSC Resources
    -- gave computer accounts access to share (full.. might only need read)
    Install-Module PSFramework (logging)

SqlServerNetwork - deprecated

-- partial vs composite



-- dsc for logins/users
    - refresh test database and logins get put back



#>