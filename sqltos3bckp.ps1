#Set-AWSCredentials myAWSCredentials


$server = '.'
$backupPath = 
$s3Bucket = ''
#$region = 'us-east-1'
$rention = 

$databases = Invoke-Sqlcmd -ServerInstance $server -Query "SELECT [name] FROM master.dbo.sysdatabases where [name] = 'MyNewDB'"

foreach ($database in $databases)
{
    $timestamp = get-date -Format MMddyyyyHHmmss
    $fileName = "$($database.name) -$timestamp.bak"
    $zipfileName = "$($database.name) -$timestamp.zip"
    $filePath = Join-Path $backupPath $fileName
    $zipfilepath = Join-Path $backupPath $zipfileName

}

Backup-SqlDatabase -ServerInstance $server -Database $database.name -BackupFile $filePath -CompressionOption On -checksum

Write-Zip -path $filePath -OutputPath $zipfilepath 

Write-S3Object -BucketName $s3Bucket -File $zipfilepath $zipfileName -Region $region


Remove-Item $backupPath$($database.name)*.bak
Remove-Item $backupPath$($database.name)*.zip


