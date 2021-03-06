
$path="C:\"
$user=""
$key=""
$dest_dir=""
$backup_dir="C:\"
$command = ". C:\"
#$today = (get-date).Date
#choose date before yesterday
$date=(Get-Date -Hour 0 -Minute 00 -Second 00).AddDays(-2)

$files = Get-ChildItem $path | where { $_.CreationTime.Date -gt $date }
$LogTime = Get-Date -Format "dd-MM-yyyy_hh-mm-ss"
		
foreach ($file in $files) {
$args = @()
$args += ("-user", $user)
$args += ("-key", $key)
$args += ("-dest_dir", $dest_dir)
$args += ("-src_path", $file.fullname)
if (!$src_path){
        #no file specified
        Write-Output "$(Get-Date –f o) no file specified"
    } 
	
    Invoke-Expression "$command $args | Out-File $backup_dir$dest_dir-

$LogTime.txt -Encoding UTF8"
}


