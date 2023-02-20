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


while($true){
    $message = ""
    $response = Invoke-WebRequest -UseBasicParsing -Uri "https://api-lok-live.leagueofkingdoms.com/api/alliance/info/my" `
    -Method "POST" `
    -WebSession $session `
    -Headers $headers `
    -ContentType "application/x-www-form-urlencoded" `
    -Body "json={}"
    $a = $response.Content | convertfrom-json
    write-host $a
    foreach($ids in $a.reddots){
        if(($ids.reddotIdx -eq 6) -and ($ids.count -gt 0)){
            write-host "Help Needed - "$ids.count -ForegroundColor Green
            $message += "`nHelp Needed - " + $ids.count
        }elseif(($ids.reddotIdx -eq 7) -and ($ids.count -gt 0)){
            $message += "`nOngoing Battle - " + $ids.count
            write-host "Ongoing Battle - " $ids.count -ForegroundColor Green
        }elseif(($ids.reddotIdx -eq 8) -and ($ids.count -gt 0)){
            $message += "`nTechnology - " + $ids.count
            write-host "Technology - "$ids.count -ForegroundColor Green
        }elseif(($ids.reddotIdx -eq 9) -and ($ids.count -gt 0)){
            $message += "`nGift - " + $ids.count
            write-host "Gift - "$ids.count -ForegroundColor Green
        }
    }
    Show-Notification -ToastTitle $message
    Start-Sleep -Seconds 300
}
