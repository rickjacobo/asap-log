param (
	[parameter(mandatory=$true,position=1)]
	$SQLPassword,
	[parameter(mandatory=$true,position=2,helpmessage="Developer,Express,Standard,Enterprise,or EnterpriseCore")]
	[ValidateSet("Developer","Express","Standard","Enterprise","EnterpriseCore")]
	$SQLVersion,
	[parameter(mandatory=$false,position=3)]
	$Name="sqlserver",
	[parameter(mandatory=$false,position=4)]
	$Port="1433",
	[parameter(mandatory=$true,position=5,helpmessage='Enter "Yes" to accept EULA or "No" to reject EULA ')]
	[ValidateSet("Yes","No")]
	$AcceptEula
)

if (($AcceptEula -eq "Yes") -or ($AcceptEula -eq "yes")){
	if ($Port){$Port = "$Port" + ":" + "1433"}
	else {$Port = "1433" + ":" + "1433"}
docker run -d --name="$Name" -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SQLPassword" -e "MSSQL_PID=Express" -p $Port mcr.microsoft.com/mssql/server:2019-latest
}
