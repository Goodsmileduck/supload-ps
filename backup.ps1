
$path="C:\Users\Stanislav\Documents\GitHub\"
$user="35812_gaio"
$key="DTH6c5yYvG"
$dest_dir="gaio.rf"
$backup_dir="C:\Users\Stanislav\Documents"
$command = ". C:\Users\Stanislav\Documents\GitHub\supload-ps\supload-ps.ps1"
$today = (get-date).Date

$files = Get-ChildItem $path | where { $_.CreationTime.Date -eq $today }

		
foreach ($file in $files) {
$args = @()
$args += ("-user", $user)
$args += ("-key", $key)
$args += ("-dest_dir", $dest_dir)
$args += ("-src_path", $file.fullname)
$LogTime = Get-Date -Format "dd-MM-yyyy_hh-mm-ss"
    Invoke-Expression "$command $args | Out-File $backup_dir\$dest_dir-$LogTime.txt -Encoding UTF8"
}

