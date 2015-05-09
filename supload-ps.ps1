function Supload
{
    <#
    .SYNOPSIS
    Script for upload files to cloud storage supported
    Cloud Files API (such as OpenStack Swift).

    Author: Stanislav Serebrennikov, Twitter: @Goodsmileduck
    License: 
    Required Dependencies: None
    Optional Dependencies: None
    Version: 0.1
    .DESCRIPTION
    Script for upload files to cloud storage supported
    Cloud Files API (such as OpenStack Swift).
    .PARAMETER NewParametr
    
    .EXAMPLE
    
    .NOTES
    supload-ps.ps1 [-a AUTH_URL] -u <USER> -k <KEY> [options] <dest_dir> <src_path>
    .LINK

    Github repo: https://github.com/goodsmileduck/supload-ps
    #>
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$arg1,
        [string]$arg2
    )
# Defaults
$auth_url="https://auth.selcdn.ru/"
$user=""
$key=""
$dest_dir=""
$src_path=""

#Определяем имя файла из пути
$filename = 
#Формируем заголовки для процесса аутентификации
$headers_auth =  New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers_auth.Add("X-Auth-User", "$user")
$headers_auth.Add("X-Auth-Key", "$key")

#Отправляем запрос на аутентификацию
$response_auth = Invoke-WebRequest -Uri $auth_url -Method Get -Headers $headers_auth

#Определяем url для загрузки
$upload_url = $response_auth.Headers."X-Storage-Url"+$dest_dir+$filename
#Формируем заголовок с токеном который получили
$headers =  New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("X-Auth-Token", "")

$response = Invoke-WebRequest -Uri $upload_url -Method Put -Headers $headers 
-inFile $src_path





}