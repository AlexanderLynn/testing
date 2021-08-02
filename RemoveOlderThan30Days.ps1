#Variables
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$Current_Date = $Date
   #Folder with files to be deleted and how many days old
$Folder = "C:\Users\$env:USERNAME\Downloads"
$Days = 0
   #Log Directory
$Drive = "C:\"
$Folder_Name = "Logs\CustomerDataRemoval\"
$Log_Folder = $Drive+$Folder_Name
   #File count, initial and post deletion
$Init_Count = 0
$Post_Count = 0
$Hostname = hostname
#Creates folder if it doesn't exist
if (Test-Path -Path $Log_Folder) {
   Write-Output "Directory Exists!"}
else {
   New-Item -Path $Drive -Name $Folder_Name -ItemType "Directory"}
#Counts files to be removed
Write-Output $Hostname | Out-File $Log_Folder$Current_Date.log -Append
Write-Output "Files in $Folder older than $Days days removed and listed in: "$Log_Folder$Current_Date
Write-Output "Files older than $Days days to be deleted:"
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays($Days)} |
ForEach-Object {
   $Init_Count++
}
Write-Output $Init_Count
Write-Output "Files deleted:" | Out-File $Log_Folder$Current_Date.log -Append
Write-Output $Init_Count | Out-File $Log_Folder$Current_Date.log -Append
   #Lists, logs, then deletes files
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays($Days)} |
ForEach-Object {
   Write-Output $_.FullName
   $_ | del -Force
   $_.FullName | Out-File $Log_Folder$Current_Date.log -Append
}
   #Reports files not deleted
Write-Output "Files older than $Days days old remaining:"
Get-ChildItem $Folder -Recurse -Force -ea 0 |
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays($Days)} |
ForEach-Object {
   $Post_Count++
}
Write-Output $Post_Count
Write-Output "Files older than $Days days old remaining:" | Out-File $Log_Folder$Current_Date.log -Append
Write-Output $Init_Count | Out-File $Log_Folder$Current_Date.log -Append
