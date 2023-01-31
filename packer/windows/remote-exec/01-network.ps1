cmd.exe /c reg add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff"
Rename-NetAdapter "Ethernet Instance 0" -NewName "eth0"
