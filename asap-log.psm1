function Add-AsapLogConfiguration {
param (
    [parameter(mandatory=$true,position=1)]
    $SQLHost,
    [parameter(mandatory=$true,position=2)]
    $SQLUsername,
    [parameter(mandatory=$true,position=3)]
    $SQLPassword,
    [parameter(mandatory=$true,position=4)]
    $SQLDatabase,
    [parameter(mandatory=$true,position=5)]
    $SQLTable
)    

$Configuration = @"
{
    "sqlhost" : "$SQLHost",
    "sqlusername" : "$SQLUsername",
    "sqlpassword" : "$SQLPassword",
    "sqldatabase" : "$SQLDatabase",
    "sqltable" : "$SQLTable"
 }
"@

$Configuration | Out-File configuration.json -Force

}

function Add-AsapLogDatabase {
    param (

    )    
 #Requires -Modules sqlserver 
 $Configuration = "configuration.json"
 if (Test-Path -Path $Configuration){} else {Add-AsapLogConfiguration}
 $Values = Get-Content $Configuration | ConvertFrom-Json
 $SQLHost = $Values.sqlhost
 $SQLUsername = $Values.sqlusername
 $SQLPassword = $Values.sqlpassword
 $SQLDatabase = $Values.sqldatabase
 $SQLTable = $Values.sqltable
 
 Invoke-Sqlcmd -ServerInstance $SQLHost -Username $SQLUsername -Password $SQLPassword -Query "CREATE DATABASE $SQLDatabase;"
 Invoke-Sqlcmd -ServerInstance $SQLHost -Username $SQLUsername -Password $SQLPassword -Database $SQLDatabase -Query "CREATE TABLE $SQLTable (id varchar(50), Log varchar(50), description varchar(50), notes varchar(50), status varchar(50), updated varchar(50), created varchar(50), PRIMARY KEY (id));"
}
function Add-AsapLog {
param (
    [parameter(mandatory=$true,position=1)]
    $Log,
    [parameter(mandatory=$true,position=2)]
    $Description,
    [parameter(mandatory=$true,position=3)]
    $Notes,
    [parameter(mandatory=$true,position=4)]
    $Status
)
#Requires -Modules sqlserver
$Configuration = "configuration.json"
if (Test-Path -Path $Configuration){} else {Add-AsapLogConfiguration}
$Values = Get-Content $Configuration | ConvertFrom-Json
$SQLHost = $Values.sqlhost
$SQLUsername = $Values.sqlusername
$SQLPassword = $Values.sqlpassword
$SQLDatabase = $Values.sqldatabase
$SQLTable = $Values.sqltable

$Id = New-Guid
$Timestamp = Get-Date -f "yyyy-MMdd hh:mm:ss"

$Query = @"
INSERT INTO $SQLTable (id,Log,description,notes,status,updated,created)
VALUES ('$Id','$Log','$Description','$Notes','$Status','$Timestamp','$Timestamp')
"@

Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query

}

function Get-AsapLog {
param (
 [parameter(mandatory=$false,position=1)]
 $Id
)
#Requires -Modules sqlserver
$Configuration = "configuration.json"
if (Test-Path -Path $Configuration){} else {Add-AsapLogConfiguration}
$Values = Get-Content $Configuration | ConvertFrom-Json
$SQLHost = $Values.sqlhost
$SQLUsername = $Values.sqlusername
$SQLPassword = $Values.sqlpassword
$SQLDatabase = $Values.sqldatabase
$SQLTable = $Values.sqltable

if ($Id){
$Query = @"
SELECT * FROM $SQLTable WHERE id='$Id';
"@
}
else {
$Query = @"
SELECT * FROM $SQLTable;
"@
}

Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query

}


function Set-AsapLog {
    param (
        [parameter(mandatory=$true,position=1)]
        $Id,
        [parameter(mandatory=$false,position=2)]
        $Log,
        [parameter(mandatory=$false,position=3)]
        $Description,
        [parameter(mandatory=$false,position=4)]
        $Notes,
        [parameter(mandatory=$false,position=5)]
        $Status
    )
        #Requires -Modules sqlserver
        $Configuration = "configuration.json"
        if (Test-Path -Path $Configuration){} else {Add-AsapLogConfiguration}
        $Values = Get-Content $Configuration | ConvertFrom-Json
        $SQLHost = $Values.sqlhost
        $SQLUsername = $Values.sqlusername
        $SQLPassword = $Values.sqlpassword
        $SQLDatabase = $Values.sqldatabase
        $SQLTable = $Values.sqltable

$Timestamp = Get-Date -f "yyyy-MMdd hh:mm:ss"

if ($Log){
$Query = @"
UPDATE $SQLTable
SET Log='$Log'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

if ($Description){
$Query = @"
UPDATE $SQLTable
SET description='$Description'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

if ($Notes){
$Query = @"
UPDATE $SQLTable
SET notes='$Notes'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

if ($Status){
$Query = @"
UPDATE $SQLTable
SET status='$Status'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

$Query = @"
UPDATE $SQLTable
SET updated='$Timestamp'
WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query

}

function Remove-AsapLog {
param (
    [parameter(mandatory=$true,position=1)]
    $Id

)
#Requires -Modules sqlserver
$Configuration = "configuration.json"
if (Test-Path -Path $Configuration){} else {Add-AsapLogConfiguration}
$Values = Get-Content $Configuration | ConvertFrom-Json
$SQLHost = $Values.sqlhost
$SQLUsername = $Values.sqlusername
$SQLPassword = $Values.sqlpassword
$SQLDatabase = $Values.sqldatabase
$SQLTable = $Values.sqltable

$Query = @"
DELETE FROM $SQLTable WHERE id='$Id';
"@
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}

function Invoke-AsapLogDBQuery {
    param (
        [parameter(mandatory=$true,position=1)]
        $Query
    
    )
    #Requires -Modules sqlserver
    $Configuration = "configuration.json"
    if (Test-Path -Path $Configuration){} else {Add-AsapLogConfiguration}
    $Values = Get-Content $Configuration | ConvertFrom-Json
    $SQLHost = $Values.sqlhost
    $SQLUsername = $Values.sqlusername
    $SQLPassword = $Values.sqlpassword
    $SQLDatabase = $Values.sqldatabase
    $SQLTable = $Values.sqltable
    
Invoke-Sqlcmd -ServerInstance $SQLHost -Database $SQLDatabase -Username $SQLUsername -Password $SQLPassword -Query $Query
}


Export-ModuleMember -Function Add-AsapLogConfiguration
Export-ModuleMember -Function Add-AsapLogDatabase
Export-ModuleMember -Function Add-AsapLog
Export-ModuleMember -Function Get-AsapLog
Export-ModuleMember -Function Set-AsapLog
Export-ModuleMember -Function Remove-AsapLog
Export-ModuleMember -Function Invoke-AsapLogDBQuery
