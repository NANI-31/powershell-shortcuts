function fch { flutter run -d chrome }
function fc { flutter clean }
function fdev { flutter devices }
function fd { flutter doctor }
function fb { flutter build apk }

function fu { flutter pub upgrade }
function fg { flutter pub get }
function fo { flutter pub outdated }

function f {
    Invoke-FolderScript -TargetFolder "CollegeBusTrackingFlutterApp" -Command "flutter run"
}

function adb1{
    Invoke-FolderScript -TargetFolder "CollegeBusTrackingFlutterApp" -Command "flutter run -d 192.168.29.181:5555  --dart-define=API_HOST=192.168.29.27 --dart-define=API_PORT=5000"
}

function adb2{
    Invoke-FolderScript -TargetFolder "CollegeBusTrackingFlutterApp" -Command "flutter run -d 192.168.29.22:5555  --dart-define=API_HOST=192.168.29.27 --dart-define=API_PORT=5000"
}

function adbc {
    # Get all connected devices
    $devices = adb devices | Select-String "device$" | ForEach-Object { ($_ -split "`t")[0] }

    if ($devices.Count -eq 0) {
        Write-Host "No devices connected!" -ForegroundColor Red
        return
    }

    Write-Host "Found devices:" $devices

    # Open multiple terminals inside VS Code
    $i = 1
    foreach ($device in $devices) {
        Write-Host "Setting up device $device..."
        adb -s $device reverse tcp:5000 tcp:5000

        # VS Code terminal command (split terminals)
        Write-Host "Run in terminal ${i}: flutter run -d $device" -ForegroundColor Cyan
        $i++
    }
}

function adb11 {
    $DeviceId = "10BDAB187B0004J"

    #Write-Host "Setting up ADB reverse for device $DeviceId..."
    #adb -s $DeviceId reverse tcp:5001 tcp:5000

    Write-Host "Running Flutter on device $DeviceId..."
    #flutter run -d $DeviceId --dart-define=SERVER_PORT=5001
    flutter run -d 192.168.29.181:5555 --dart-define=API_HOST=192.168.29.27 --dart-define=API_PORT=5000
}

function adb22 {
    $DeviceId = "GYTG8L7TFMIVSS6P"

    #Write-Host "Setting up ADB reverse for device $DeviceId..."
    #adb -s $DeviceId reverse tcp:5002 tcp:5000

    Write-Host "Running Flutter on device $DeviceId..."
    #flutter run -d 192.168.29.181:5555  --dart-define=SERVER_PORT=5002
    flutter run -d 192.168.29.22:5555  --dart-define=API_HOST=192.168.29.27 --dart-define=API_PORT=5000
}