<#
.SYNOPSIS
    This script will take access token as input and will perform some basic tasks.
.DESCRIPTION
    Got to provide access token and then it'll perform the following tasks:
        1. It'll help people whoever asks for help in the game.
        2. It'll do donation of the recomended technology in the game.
        3. It'll claim all the gifts that are received in the dragon fights.
.NOTES
    Author: Ankit Agarwal
    Last Edit: 20th Feb 2023
    Version 1.0 - initial release of Script
#>



function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = "PowerShell"
    $Toast.Group = "PowerShell"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
    $Notifier.Show($Toast);
}

$accesstoken = read-host "Enter access token"



$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
$headers = @{
    "Accept"="*/*"
      "Accept-Encoding"="gzip, deflate, br"
      "Accept-Language"="en-IN,en-GB;q=0.9,en-US;q=0.8,en;q=0.7"
      "DNT"="1"
      "Origin"="https://play.leagueofkingdoms.com"
      "Referer"="https://play.leagueofkingdoms.com/"
      "Sec-Fetch-Dest"="empty"
      "Sec-Fetch-Mode"="cors"
      "Sec-Fetch-Site"="same-site"
      "sec-ch-ua"="`"Not_A Brand`";v=`"99`", `"Google Chrome`";v=`"109`", `"Chromium`";v=`"109`""
      "sec-ch-ua-mobile"="?0"
      "sec-ch-ua-platform"="`"Windows`""
      "x-access-token"=$accesstoken

    }

function getAllianceInfo(){
    $response = Invoke-WebRequest -UseBasicParsing -Uri "https://api-lok-live.leagueofkingdoms.com/api/alliance/info/my" `
    -Method "POST" `
    -WebSession $session `
    -Headers $headers `
    -ContentType "application/x-www-form-urlencoded" `
    -Body "json={}"
    return $response
}

function donateAll(){
    $response = Invoke-WebRequest -UseBasicParsing -Uri "https://api-lok-live.leagueofkingdoms.com/api/alliance/research/donateAll" `
    -Method "POST" `
    -WebSession $session `
    -Headers $headers `
    -ContentType "application/x-www-form-urlencoded" `
    -Body "json=%7B%22code%22%3A31102003%7D"
    return $response
}

function helpAll(){
    $response = Invoke-WebRequest -UseBasicParsing -Uri "https://api-lok-live.leagueofkingdoms.com/api/alliance/help/all" `
    -Method "POST" `
    -WebSession $session `
    -Headers $headers `
    -ContentType "application/x-www-form-urlencoded" `
    -Body "json={}"
    return $response
}

function claimAllGifts(){

    Invoke-WebRequest -UseBasicParsing -Uri "https://api-lok-live.leagueofkingdoms.com/api/alliance/gift/claim/all" `
    -Method "POST" `
    -WebSession $session `
    -Headers $headers `
    -ContentType "application/x-www-form-urlencoded" `
    -Body "json={S0w=}"
    return $response
}


while($true){
    $message = ""
    $timeToSleep = (Get-Random -Minimum 0.9 -Maximum 4.9) * 60
    <#
    $response = Invoke-WebRequest -UseBasicParsing -Uri "https://api-lok-live.leagueofkingdoms.com/api/alliance/info/my" `
    -Method "POST" `
    -WebSession $session `
    -Headers $headers `
    -ContentType "application/x-www-form-urlencoded" `
    -Body "json={}"
    #>
    $response = getAllianceInfo
    $a = $response.Content | convertfrom-json
    #write-host $a
    if($a.result -eq $false){
        Show-Notification -ToastTitle "Refresh the game page and rerun the code with new access token"
        break
    }
    foreach($ids in $a.reddots){
        if(($ids.reddotIdx -eq 6) -and ($ids.count -gt 0)){
            write-host "Help Needed - "$ids.count -ForegroundColor Green
            $response = helpAll | convertfrom-json
            $message += "`nHelp Needed - " + $ids.count
            $message += "`nHelped - " + $response.result
            write-host "Helped - "$response.result -ForegroundColor Green
        }elseif(($ids.reddotIdx -eq 7) -and ($ids.count -gt 0)){
            $message += "`nOngoing Battle - " + $ids.count
            write-host "Ongoing Battle - " $ids.count -ForegroundColor Green
        }elseif(($ids.reddotIdx -eq 8) -and ($ids.count -gt 0)){
            write-host "Technology - "$ids.count -ForegroundColor Green
            $response = donateAll | convertfrom-json
            $message += "`nTechnology - " + $ids.count
            $message += "`nTechnology Donated - " + $response.result
            write-host "Technology Donated - "$response.result -ForegroundColor Green
        }elseif(($ids.reddotIdx -eq 9) -and ($ids.count -gt 0)){
            write-host "Gift - "$ids.count -ForegroundColor Green
            $response = claimAllGifts | convertfrom-json
            $message += "`nGift - " + $ids.count
            $message += "`nGifts claimed - " + $response.result
            write-host "Gifts claimed - "$response.result -ForegroundColor Green
        }
    }
    if($message -ne ""){
        Show-Notification -ToastTitle $message
    }
    $currentTime = Get-Date -UFormat "%A %m/%d/%Y %R %Z"
    write-host $currentTime
    write-host "Time to sleep - " $timeToSleep
    Start-Sleep -Seconds $timeToSleep
}

