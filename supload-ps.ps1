
    <#
    .SYNOPSIS
    Script for upload files to cloud storage supported
    Cloud Files API (such as OpenStack Swift).
	
    !!!Version 0.1 upload only one last file!!!
	
    Author: Stanislav Serebrennikov, Twitter: @Goodsmileduck
    License: 
    Required Dependencies: None
    Optional Dependencies: None
    Version: 0.1
    .DESCRIPTION
    Script for upload files to cloud storage supported
    Cloud Files API (such as OpenStack Swift).
    .PARAMETER -user
    
    .EXAMPLE
    .\supload-ps -user MyUser -key MyPassword TEST_DIR c:\Backup\ -onlylast
	.EXAMPLE
	.\supload-ps -user MyUser -key MyPassword TEST_DIR c:\Backup\text.txt
    .NOTES
    supload-ps.ps1 -u <USER> -k <KEY> <dest_dir> <src_path>
    .LINK

    Github repo: https://github.com/goodsmileduck/supload-ps
    #>

    param(
        [Parameter(Mandatory=$True, Position=1)]
        [string]$user,
		[Parameter(Mandatory=$True, Position=2)]
        [string]$key,
		[Parameter(Mandatory=$True, Position=3)]
		[string]$dest_dir,
		[Parameter(Mandatory=$True, Position=4)]
		[string]$src_path,
		[Parameter(Mandatory=$False)]
		[switch]$onlylast
		
    )
# Defaults
$auth_url="https://auth.selcdn.ru/"

if ($onlylast)
{
    $file = dir $src_path | sort CreationTime | Select -Last 1 -Exp fullname
}
else
{
    $file=$src_path
}
#Вычисляем хеш
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($file))) -replace "-",""

#Определяем имя файла из пути
$filename = Split-Path $file -Leaf
#Формируем заголовки для процесса аутентификации
$headers_auth =  New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers_auth.Add("X-Auth-User", "$user")
$headers_auth.Add("X-Auth-Key", "$key")
#Хорошо бы это был Powershell >3 
if ($PSVersionTable.PSVersion.Major -gt 2){
#Отправляем запрос на аутентификацию
$response_auth = Invoke-WebRequest -Uri $auth_url -Method Get -Headers $headers_auth


#Определяем url для загрузки
$upload_url = $response_auth.Headers."X-Storage-Url" + $dest_dir + "/" + $filename
#Формируем заголовок с токеном который получили
$headers =  New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("X-Auth-Token", $response_auth.Headers."X-Auth-Token")
$headers.Add("etag", "$hash")
#Если хеш файла не совпадает получаем 503
$upload = Invoke-WebRequest -Uri $upload_url -Method Put -Headers $headers -InFile $file
}
else {
#Что же если это не 3 версия Powershell
$webclient = New-Object System.Net.WebClient 
$webclient.Headers.Add("X-Auth-User", "$user")
$webclient.Headers.Add("X-Auth-Key", "$key")
$webclient.DownloadString($auth_url)
$upload_url = $webclient.ResponseHeaders.get("X-Storage-Url") + $dest_dir + "/" + $filename
#Давайте попробуем все в этой жизни! И Скажем спасибо .NET v2
$req = [System.Net.WebRequest]::Create("$upload_url")
$req.Method = "PUT"
$req.SendChunked = $true
#Задаем загаловки с токеном и etag(проверка md5 после загрузки)
$req.Headers.Add("X-Auth-Token", $webclient.ResponseHeaders.get("X-Auth-Token"))
$req.Headers.Add("etag", "$hash")
#Читаем фаил
$data = [System.IO.File]::ReadAllBytes("$file")
$req.ContentLength = $data.Length
$reqstream = $req.GetRequestStream()
$reqstream.Write($data, 0, $data.Length)
$reqstream.Close()

}


# Надо права администратора
#if ($response.StatusCode == 201)
#{
#New-EventLog –LogName Application –Source “Suplouad”
#Write-EventLog –LogName Application –Source “Supload” –EntryType Information –EventID 1 –Message “Файл $src_path успешно скопирован”
#}
#Здесь мы хоть что то будет показывать, но не сейчас
#Write-Output $upload.StatusCode


