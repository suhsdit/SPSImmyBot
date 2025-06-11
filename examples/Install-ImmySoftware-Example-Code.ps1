# This is copied and pasted as powershell out of the network tab while trying to do a 1 time install of Notepad++ to my PC
# The interesting bits appear to happen in the body below.


$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
$session.Cookies.Add((New-Object System.Net.Cookie("ai_user", "aVt0ymzEf2q0spJyxT+LpY|2022-01-26T16:31:28.569Z", "/", "contoso.immy.bot")))
$session.Cookies.Add((New-Object System.Net.Cookie("_upscope__region", "InVzLXdlc3Qi", "/", ".immy.bot")))
$session.Cookies.Add((New-Object System.Net.Cookie("_upscope__shortId", "IlNaRk1RNzRMRFpITVNZUUdDIg==", "/", ".immy.bot")))
$session.Cookies.Add((New-Object System.Net.Cookie("_upscope__waitingForCallAt", "", "/", ".immy.bot")))
$session.Cookies.Add((New-Object System.Net.Cookie("_upscope__waitingForCallAt", "", "/", ".contoso.immy.bot")))
$session.Cookies.Add((New-Object System.Net.Cookie("ARRAffinity", "b48b568b504a2b475f0a83e7162c5bf80c235fa6e48eaf7b7a20b9403375fe42", "/", ".contoso.immy.bot")))
$session.Cookies.Add((New-Object System.Net.Cookie("ARRAffinitySameSite", "b48b568b504a2b475f0a83e7162c5bf80c235fa6e48eaf7b7a20b9403375fe42", "/", ".contoso.immy.bot")))
$session.Cookies.Add((New-Object System.Net.Cookie("AppServiceAuthSession", "9FVCYOkSKboZaajkogFkewF901ksx1sEZWPCBGcLuuKyq1LisnveUSNxvnTMUGG08xaQnQrrhmYuRa+ZqEbspNT8f/rspj92hO21db2/nsTX38D6Kuo42KxVb4RF5zx8noDV3y8/6LZyOClq6IM3Duo7eNla0q1yea8+u/t/3fB+wSlZm+bMIn711KcNU73ziNlruQ93q/cv0+QP4vZFXNyn2MlArfCyTNNrBaSFqQpx+W+xetWKjfgukarm3Tlwz8VeVx7T6O/7zFawUcBwnFHy7x2JxFmNUEs+T8Di9kaDrUELfp1StUF+aXeRdGTbf+xHqg0VswxU3xdSLnqU5J4zeOWPlDYyotpDrG4SAtIjYIJNSOI2EOfIaM30Lp2QQuYXOTxLFAO+aKZr4lqcsZSyYOaEZtl4H+vVSCLMe7xa0cyxo3WE1OSYg+Jl6SCa0jTV3ijtSpZiRs8NsuIGO3PkZ0ziddCmNa6dk0o28JoNYub0W24G4MblHBnfQ6ar0ZT3cDAdWRsInrdxFvaa5KjJI+WSnT/u63bVS5exHVSIiLWV4Vc6yQnVWacnMQm5njMYwtv/DPd+RVUdm4ukeyPoyGhe1usy+hkGdSn+FtjzWmbhcdvM5Fs1ikdkN3Xf6/MXtc4OvvmUvZIePJNpNHD3qfmUWczyE64SaJh7Ze70vwfR/PlWk0fYPkYwjrqqulk5XgAR+deeKp5lBN3a2I9BoiQ5Zl1yF+RPG0M3NYZQyyEW9QwAkbieEXwrkToFW7/8dMME1bo9kKfG2Cig5heTwtRVxxyhd2mNnHezmXdzQ9kKoYD4KdPbR4YfYr1O+081mhosWLHtmlXnL0ctlqfscgSS3QFM0wUZxJjjff9xsVxLt828AnvNvnDv10fie0qcpLCH5o9nnD2RpIxh0xyySNsW9kqewph6fdq1ttHrpvykHLuJLtqHXd3LBHKqX28puBFGg58wMTZnYAEZqbPC2384eBIqZvXOTfRC+YNw8vJjenkoFqJ2msdd0G9LJx/kOhID9dI3NU2aajU8yNHVvtDt4iq56XOfMxsf0A3MLJcWhH1uBAdOfoOtWbJENq7XA7XqhyuJMqlcMBuIjB5Rqlj+Bcr4Nnf4+AOwwATo+EGqnNejPU4xaD/oOoZzLGIhe3DfVO1l2C4ZaMljgx9Gc/mR8yVTnQK8LM23x9Ov5GJWmgr1i6l2ypE3wdV8MsTR+T9zq5N0FWmPTQgfdP14bOjCVnYQLLR9c1fBpr/WGwRQh2NU+wYAyHbqdPXs9KnJ/Pigw5RykaDFX0GEew==", "/", "contoso.immy.bot")))
$session.Cookies.Add((New-Object System.Net.Cookie("ai_session", "QWz+ZiHRp0VTPiGFGrrOAn|1657654486363|1657654880227", "/", "contoso.immy.bot")))
Invoke-WebRequest -UseBasicParsing -Uri "https://contoso.immy.bot/api/v1/run-immy-service" `
-Method "POST" `
-WebSession $session `
-Headers @{
"authority"="contoso.immy.bot"
  "method"="POST"
  "path"="/api/v1/run-immy-service"
  "scheme"="https"
  "accept"="application/json, text/plain, */*"
  "accept-encoding"="gzip, deflate, br"
  "accept-language"="en-US,en;q=0.9"
  "authorization"="Bearer PAQABAAAAAAD--DLA3VO7QrddgJg7Wevri5ePD77t90geQjU8KHO80GuhzZ-LIHE6XxpvVg34Medik0MRfn4i6YzgrXV59iGrBF6MWuks3bpTQV-F--dKxDwplrm1NIr3hvMJE-PNVYr5ha_ioWJTPoZ5WFuQ3rUx7vZu_vmmjtex2bJFuZsRSM2QHvB6arAAEbG5Vs3lLfDSHCtocCdFtIVyojeqcUaSj2nJRgMYV8mo7gwrkduUtB3mVz6UR92FsWA1sbylGKZTbhHjehHN60YZm5-k3HJiA8tSHQOioDc9MqIfSGiNTo7dmM-xSWAwqXaFtwxVucl5kWeGnocITcTBtiT6TzxQGiqXSzGmg6Dn2L-Y6xzNMZ544-E_QCfIQlikEtHjp4xhx7vejrDa6MwhaGtEOx1kEv0CWo1hyq4TmzGPi_U6Acng_bSXt9fy4niyZsb8IbHPdbntVy5Avj5Ck8ZlPCnIht4DRdMP6q6dBQ-pQbKgA_vm9siy3tr-FxJSrjSuJeMTwhU2eTpPTkYO5KiiRUb28Im0hE9MbZ5As54dnrE387ykHP_GJr83x6vlzpxCLmbCqVVhSLXhPL_V0YlJoO6sSrEzxmQdwj9hPiboo_tIs7UKRWecrZ3Ohp0bdxT8l43kv5JRMFIzWHIWY4J9KarwP3WxjsRme3-AKsJmBqZvRzzCu8QuskxhgWr3WX5WMe-QqXOA-oMw604OE5B6iztpvuGroRP1AcJevTuCDMJ8WZyaBjHudC8m7TrTCNRLE0YgAA"
  "dnt"="1"
  "origin"="https://contoso.immy.bot"
  "referer"="https://contoso.immy.bot/computers/8/software"
  "request-context"="appId=cid-v1:1c9cc000-c061-47a4-ac59-e793bd17f254"
  "request-id"="|074c6542b6e64658a4278e0b86721f91.2745780e227e4ece"
  "sec-ch-ua"="`".Not/A)Brand`";v=`"99`", `"Google Chrome`";v=`"103`", `"Chromium`";v=`"103`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "sec-fetch-dest"="empty"
  "sec-fetch-mode"="cors"
  "sec-fetch-site"="same-origin"
  "traceparent"="00-074c6542b6e64658a4278e0b86721f91-2745780e227e4ece-01"
} `
-ContentType "application/json;charset=UTF-8" `
#
# The interesting stuff starts below here within the body
#
# maintenanceIdentifier 313 refers to Software 313 which is notepad++
# Computers - Computer ID's to deploy to
-Body "{`"maintenanceParams`":{`"maintenanceIdentifier`":`"313`",`"maintenanceType`":0,`"repair`":false,`"desiredSoftwareState`":5,`"maintenanceTaskMode`":0,`"maintenanceTaskParameterValues`":[]},`"skipBackgroundJob`":true,`"cacheOnly`":false,`"rebootPreference`":1,`"fullMaintenance`":false,`"detectionOnly`":false,`"resolutionOnly`":false,`"runInventoryInDetection`":false,`"offlineBehavior`":2,`"suppressRebootsDuringBusinesshours`":false,`"sendDetectionEmail`":false,`"sendFollowUpEmail`":false,`"sendFollowUpOnlyIfActionNeeded`":false,`"showRunNowButton`":false,`"showPostponeButton`":false,`"showMaintenanceActions`":false,`"computers`":[{`"computerId`":8}],`"tenants`":[]}"

$body = "{`"maintenanceParams`":{`"maintenanceIdentifier`":`"313`",`"maintenanceType`":0,`"repair`":false,`"desiredSoftwareState`":5,`"maintenanceTaskMode`":0,`"maintenanceTaskParameterValues`":[]},`"skipBackgroundJob`":true,`"cacheOnly`":false,`"rebootPreference`":1,`"fullMaintenance`":false,`"detectionOnly`":false,`"resolutionOnly`":false,`"runInventoryInDetection`":false,`"offlineBehavior`":2,`"suppressRebootsDuringBusinesshours`":false,`"sendDetectionEmail`":false,`"sendFollowUpEmail`":false,`"sendFollowUpOnlyIfActionNeeded`":false,`"showRunNowButton`":false,`"showPostponeButton`":false,`"showMaintenanceActions`":false,`"computers`":[{`"computerId`":8}],`"tenants`":[]}" |
    ConvertFrom-Json

$body # Results
# maintenanceParams                  : @{maintenanceIdentifier=313; maintenanceType=0; repair=False; desiredSoftwareState=5; maintenanceTaskMode=0;
#                                      maintenanceTaskParameterValues=System.Object[]}
# skipBackgroundJob                  : True
# cacheOnly                          : False
# rebootPreference                   : 1
# fullMaintenance                    : False
# detectionOnly                      : False
# resolutionOnly                     : False
# runInventoryInDetection            : False
# offlineBehavior                    : 2
# suppressRebootsDuringBusinesshours : False
# sendDetectionEmail                 : False
# sendFollowUpEmail                  : False
# sendFollowUpOnlyIfActionNeeded     : False
# showRunNowButton                   : False
# showPostponeButton                 : False
# showMaintenanceActions             : False
# computers                          : {@{computerId=8}}
# tenants                            : {}

$body.maintenanceParams # Results
# maintenanceIdentifier          : 313  
# maintenanceType                : 0    
# repair                         : False
# desiredSoftwareState           : 5
# maintenanceTaskMode            : 0
# maintenanceTaskParameterValues : {}