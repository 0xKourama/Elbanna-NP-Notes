cd .\Downloads\Downloads\
mv .\device_state_cfg.tgz PA_220_device_state_cfg.tgz
mv '.\device_state_cfg (1).tgz' PA_221_device_state_cfg.tgz
mv '.\device_state_cfg (2).tgz' WP_Router_device_state_cfg.tgz
mv '.\device_state_cfg (3).tgz' MISR_PA_device_state_cfg.tgz
mv '.\device_state_cfg (4).tgz' AWS_PA_device_state_cfg.tgz
mkdir bkp
ls -File | %{mv $_.fullname .\bkp\}
Compress-Archive .\bkp\ "$(((get-date).date).toshortdatestring() -replace '/','-')-backup.zip"
rm -Force -Recurse .\bkp\
start .
