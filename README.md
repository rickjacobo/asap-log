# asap-log
A PowerShell Module to log work using a Microsoft SQL backend.

## Requirements
* Container Platform (ie., Docker, Kubernetes, Rancher Desktop, etc...)
* Microsoft SQL Database
* PowerShell
  * sqlserver module
  ````
  Install-Module -Name sqlserver
  Import-Module -Name sqlserver
  ````
* Git

## Setup Environment
* Download bits
````
git clone https://github.com/rickjacobo/asapLog
````
* If you don't already have a Microsoft SQL encvironment run Start-SQLContainer.ps1 setup wizard (MUST BE RUN FROM MODULE DIRECTORY)
````
./Start-SQLContainer.ps1
````
or
````
docker run -d --name="<name of container>" -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<secure password>" -e "MSSQL_PID=Express" -p $Port mcr.microsoft.com/mssql/server:2019-latest
````

* Import AsapLog Module (MUST BE RUN FROM MODULE DIRECTORY)
````
Import-Module asap-log.psm1
````

* Setup Database  (MUST BE RUN FROM MODULE DIRECTORY)
````
Add-AsapLogDatabase
````

* Add Log (MUST BE RUN FROM MODULE DIRECTORY)
````
Add-AsapLog -Log <log> -Description <description> -Notes <notes> -Status <status>
````

* Get Log (MUST BE RUN FROM MODULE DIRECTORY)
````
Get-AsapLog
````

* Update Log (MUST BE RUN FROM MODULE DIRECTORY)
  * Get Id with Get-AsapLog
````
Set-AsapLog -Id <obtain from Get-AsapLog> -Log <log> -Description <description> -Notes <notes> -Status <status>
````

* Remove Log (MUST BE RUN FROM MODULE DIRECTORY)
  * Get Id with Get-AsapLog
```
Remove-AsapLog -Id <obtain from Get-AsapLog>
````
