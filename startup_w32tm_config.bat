
rem "Reset service to default"
net stop w32time
w32tm /debug /disable
w32tm /unregister
ping -n 3 127.0.0.1

w32tm /register
ping -n 3 127.0.0.1

rem "Set service autostart with net link on/off"
sc triggerinfo w32time start/networkon stop/networkoff

rem "Allow large offset sync"
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config /v MaxNegPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config /v MaxPosPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f
rem "set sync interval to 30min"
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\W32Time\TimeProviders\NtpClient /v SpecialPollInterval /d 0x00000708 /t REG_DWORD /f

net start w32time

rem "Setup new config"
w32tm /config /manualpeerlist:"78.26.180.80" /syncfromflags:manual /reliable:yes /update

rem "Reread new conf"
w32tm /config /update

net stop w32time
net start w32time

rem "Force resync"
w32tm /resync /rediscover 
