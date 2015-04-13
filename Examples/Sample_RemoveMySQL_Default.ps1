
configuration SQLInstanceRemovalConfiguration
{
    
    Import-DscResource -Module msMySql
    
    node $AllNodes.NodeName
    {
        
        msMySqlServer MySQLInstance
        {
            Ensure = "Absent"
            RootPassword = $global:cred
            ServiceName = "MySQLInstanceServiceName"
        }
    }
}

<# 
Sample use (parameter values need to be changed according to your scenario):
#>

$global:pwd = ConvertTo-SecureString "pass@word1" -AsPlainText -Force
$global:usrName = "administrator"
$global:cred = New-Object -TypeName System.Management.Automation.PSCredential ($global:usrName,$global:pwd)

$path = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent

SQLInstanceRemovalConfiguration -ConfigurationData "$path\nodedata.psd1" -outputpath c:\windows\temp
Start-DscConfiguration -Path c:\windows\temp -ComputerName localhost -Wait -Verbose -Force



