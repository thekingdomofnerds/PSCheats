<#
.SYNOPSIS
    List all workstations in the domain without a Bitlocker Key.
.DESCRIPTION
    List all workstations in the domain without a Bitlocker Key.
.INPUTS
    None
.OUTPUTS
    CSV in script path
.EXAMPLE
    .\get-ComputersWithoutBitlocker.ps1
.NOTES
    Author:             Amber Kirkendoll
    Date:               5/15/2019
#>

Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }


Write-Verbose "Getting Workstations..." -Verbose
$Computers = Get-ADComputer -Filter {(OperatingSystem -like "Windows*") -and (OperatingSystem -like "*") -and (OperatingSystem -notlike "*Server*") -and (Enabled -eq "True")} -Properties OperatingSystem
$Count = 1

$Results = ForEach ($Computer in $Computers)
{
    Write-Progress -Id 0 -Activity "Searching Computers for BitLocker" -Status "$Count of $($Computers.Count)" -PercentComplete (($Count / $Computers.Count) * 100)
    

    $bitlocker = get-adobject -Filter * -SearchBase $Computer.DistinguishedName -properties 'msFVE-RecoveryPassword' | Where-Object {$_.ObjectClass -eq "msFVE-RecoveryInformation"} | Select-Object -last 1 | select -ExpandProperty msFVE-RecoveryPassword
    
        if(!$bitlocker) #Filters out all computers with bitlocker
        {
            New-Object PSObject -Property @{
                ComputerName = $Computer.Name
                OS = $Computer.OperatingSystem
            }
        } #end !$bitlocker
    
    $Count ++
} #End Foreach Computer in Computers

Write-Progress -Id 0 -Activity " " -Status " " -Completed

$ReportPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) -ChildPath "PC_Without_BitLocker.csv"
Write-Verbose "Building the report..." -Verbose
$Results | Select ComputerName,OS | Sort ComputerName | Export-Csv $ReportPath -NoTypeInformation
Write-Verbose "Report saved at: $ReportPath" -Verbose








        


        
