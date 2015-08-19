$users = Import-Csv -Delimiter ";" -Path "E:\BEAUGER\Desktop\Scripts_backup\users.csv"
$Date=Get-Date -Format "yyyyMMdd"
$LogFile = "C:\"+ $date + "_logs.txt"

Start-transcript -path $LogFile

    #administrateur Credential
    $admuser=""
    $admpassword=""

    foreach ($user in $users)
    {
    #Connection au poste client
    $uncClient="\\" + $user.Computer + "\c$\Users\"
    net use $uncClient
    

    #détermination du chemin de profil source et de destination
    $ProfilPath="\\" + $user.Computer + "\c$\Users\" + $user.UserName + "\"  
    $DestinationPath = "D:\" + $date + "_" + $user.UserName + "\"

    #Copie des Signatures Outlook
    Copy-Item -Recurse  (Join-Path $ProfilPath "AppData\Roaming\Microsoft\Signatures") -Destination (Join-Path $DestinationPath "AppData\Roaming\Microsoft\Signatures") -errorAction SilentlyContinue -errorVariable errors
    if(-not $?)
    {
        Write-Warning "!!!ECHEC!!! Erreur dans la copie des signatures de l'utilisateur" + $user.UserName + "sur le poste" + $user.Computer
    }
    else
    {
        Write-Host "OK ! la copie des signatures de l'utilisateur" + $user.UserName + "sur le poste" + $user.Computer + "c'est bien éffectuée"
    }
 


    }
Stop-transcript