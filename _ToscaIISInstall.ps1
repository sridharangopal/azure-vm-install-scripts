#Run Windows Workloads config scripts
./SimpleConfig.ps1

# From: https://blogs.msdn.microsoft.com/containerstuff/2017/02/14/manage-iis-on-a-container-with-the-iis-admin-console/
Import-Module Dism

Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-CommonHttpFeatures
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-HttpErrors
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-HttpRedirect
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-HealthAndDiagnostics
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-HttpLogging
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-LoggingLibraries
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-CustomLogging
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-RequestMonitor
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-HttpTracing
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-Security
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-HttpCompressionStatic
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-HttpCompressionDynamic
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-URLAuthorization
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-RequestFiltering
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-IPSecurity
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-Performance
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-IIS6ManagementCompatibility
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-Metabase
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-HostableWebCore
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-CertProvider
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WindowsAuthentication
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-BasicAuthentication
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-DigestAuthentication
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ClientCertificateMappingAuthentication
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-IISCertificateMappingAuthentication
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ODBCLogging
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-StaticContent
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-DefaultDocument
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-DirectoryBrowsing
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WebDAV
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WebSockets
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ApplicationInit
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ApplicationDevelopment
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-NetFxExtensibility
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-NetFxExtensibility45
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ASPNET
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ASPNET45
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ISAPIFilter
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ASP
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-CGI
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ServerSideIncludes
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ManagementConsole
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ManagementService
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WebServerManagementTools
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ManagementScriptingTools
Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WMICompatibility
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-LegacyScripts
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-LegacySnapIn
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-FTPServer
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-FTPSvc
#Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-FTPExtensibility

#net user localadmin sapw123!@ /ADD
#net localgroup administrators localadmin /add

# Install-WindowsFeature -name Web-Server -IncludeManagementTools
# Dism /online /enable-feature /featurename:IIS-ManagementService /all
# New-ItemProperty -Path HKLM:\software\microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1 -Force

net stop Iisadmin
net stop W3svc
#net stop wmsvc

net start Iisadmin
net start W3svc
net start wmsvc

Import-Module WebAdministration
Set-Location IIS:\SslBindings
New-WebBinding -Name "Default Web Site" -IP "*" -Port 443 -Protocol https
$c = New-SelfSignedCertificate -DnsName "ToscaDevAzure.lmig.com" -CertStoreLocation cert:\LocalMachine\My
$c | New-Item 0.0.0.0!443

# New-WebAppPool -Name plpApps
# Set-ItemProperty IIS:\AppPools\plpApps -name processModel -value @{userName="dummy";password="pw";identitytype=3}
# Set-ItemProperty IIS:\AppPools\plpApps  managedPipelineMode "Classic"
# Set-ItemProperty 'IIS:\Sites\Default Web Site' applicationPool plpApps

$workdir = "c:\temp"
New-Item $workdir -ItemType Directory
Set-Location $workdir
$MSDeployURL = "https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi"
Invoke-WebRequest -Uri $MSDeployURL -OutFile "msdeploy.msi"
#https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/dd569093(v=ws.10)#to-set-an-web-deploy-remote-service-ssl-binding-on-windows-server2003
msiexec /i msdeploy.msi ADDLOCAL=all LISTENURL=https://+:443/MsDeployAgentService/ /passive /norestart /l* MSDeployInstallLog.txt

net stop msdepsvc
net stop Iisadmin
net stop W3svc
#net stop wmsvc

net start Iisadmin
net start W3svc
net start wmsvc
net start msdepsvc
