[CmdletBinding()]
Param(
   [Parameter(Mandatory=$False)]
    [bool]$DebugMode
)

Set-ExecutionPolicy Bypass -Scope Process

$host.UI.RawUI.WindowTitle = "Myrtille Configuration . . . PLEASE DO NOT CLOSE THIS WINDOW . . ."

try
{
	# check if the service exists
	if (Get-Service "Myrtille.Services" -ErrorAction SilentlyContinue)
	{
		# stop the service
		Stop-Service -Name "Myrtille.Services"
		Write-Output "Stopped Myrtille.Services`r`n"

		# remove the service
		# the "Remove-Service" cmdlet was introduced in powershell 6.0 (so is only available on Windows server 2016 or greater); using sc instead
		#Remove-Service -Name "Myrtille.Services"
		sc.exe delete "Myrtille.Services"
		Write-Output "Removed Myrtille.Services`r`n"
	}
	else
	{
		Write-Output "Myrtille.Services doesn't exists"
	}

	if ($DebugMode)
	{
		Read-Host "`r`nPress ENTER to continue..."
	}
}
catch
{
	Write-Output $_.Exception.Message

	if ($DebugMode)
	{
		Read-Host "`r`nPress ENTER to continue..."
	}

	exit 1
}