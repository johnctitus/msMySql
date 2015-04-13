configuration SQLRemoveInstanceAndDatabaseInstallationConfiguration
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
        msMySqlDatabase MySQLDatabase
        {
            Ensure = "Absent"
            Name = "TestDB"
            ConnectionCredential = $global:cred
        }
        
        msMySqlServer MySQLInstance
        {
            Ensure = "Absent"
            ServiceName = "MySQLInstanceServiceName"
            RootPassword = $global:cred
            DependsOn = "[msMySqlDatabase]MySQLDatabase"
        }

        Package mySqlInstaller
        {
                    
            Path = $MySQLInstancePackagePath
            ProductId = $Node.PackageProductID 
            Name = $MySQLInstancePackageName
            Ensure = "Absent"
            DependsOn = "[msMySqlInstance]MySQLInstance"
        }
    }
}

<# 
Sample use (parameter values need to be changed according to your scenario):
#>

$global:pwd = ConvertTo-SecureString "pass@word1" -AsPlainText -Force
$global:usrName = "administrator"
$global:cred = New-Object -TypeName System.Management.Automation.PSCredential ($global:usrName,$global:pwd)


SQLRemoveInstanceAndDatabaseInstallationConfiguration `
    -MySQLInstancePackagePath "http://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-5.6.17.0.msi" `
    -MySQLInstancePackageName "MySQL Installer" -ConfigurationData .\nodedata.psd1



