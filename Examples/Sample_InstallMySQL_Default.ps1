
configuration SQLInstanceInstallationConfiguration
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $MySQLInstancePackagePath,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $MySQLInstancePackageName
    )
    
    Import-DscResource -Module msMySql

    node $AllNodes.NodeName
    {
        
        
        Package mySqlInstaller
        {
                    
            Path = $MySQLInstancePackagePath
            ProductId = $Node.PackageProductID 
            Name = $MySQLInstancePackageName
        }
        
        msMySqlServer MySQLInstance
        {
            Ensure = "Present"
            RootPassword = $global:cred
            ServiceName = "MySQLServerInstanceName"
            DependsOn = "[Package]mySqlInstaller"
        }
    }
}

<# 
Sample use (parameter values need to be changed according to your scenario):
#>

$global:pwd = ConvertTo-SecureString "pass@word1" -AsPlainText -Force
$global:usrName = "administrator"
$global:cred = New-Object -TypeName System.Management.Automation.PSCredential ($global:usrName,$global:pwd)

#-MySQLInstancePackagePath "http://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-5.6.17.0.msi" `
#-MySQLInstancePackagePath "http://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-5.6.24.0.msi" `
$path = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent
SQLInstanceInstallationConfiguration `
    -MySQLInstancePackagePath "http://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-5.7.7.0-rc.msi" `
    -MySQLInstancePackageName "MySQL Installer - Community" -ConfigurationData "$path\nodedata.psd1" -outputpath c:\windows\temp
Start-DscConfiguration -Path c:\windows\temp -ComputerName localhost -Wait -Verbose -Force

