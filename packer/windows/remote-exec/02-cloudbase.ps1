# https://blog.v12n.io/automating-the-installation-of-cloudbase-init-in-windows-templates-using-packer/

$msiFileName = "CloudbaseInitSetup_1_1_6_x64.msi"

Start-Process msiexec.exe -ArgumentList "/i E:\$msiFileName /qn /norestart RUN_SERVICE_AS_LOCAL_SYSTEM=1" -Wait

$confPath = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\"

$confContent = @"
[DEFAULT]
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
logdir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
logfile=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
metadata_services=cloudbaseinit.metadata.services.nocloudservice.NoCloudConfigDriveService
plugins=cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin,
        cloudbaseinit.plugins.common.sethostname.SetHostNamePlugin,
        cloudbaseinit.plugins.common.userdata.UserDataPlugin
"@

New-Item -Path $confPath -Name "cloudbase-init.conf" -ItemType File -Force -Value $confContent

Remove-Item -Path ($confPath + "cloudbase-init-unattend.conf") -Confirm:$false
Remove-Item -Path ($confPath + "Unattend.xml") -Confirm:$false

Start-Process sc.exe -ArgumentList "config cloudbase-init start= delayed-auto" -Wait
