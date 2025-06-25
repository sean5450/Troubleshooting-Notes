### On chimera:
`docker exec -ti studio bash`
edit `/code/scenarios/scattered_spider.json` with your text editor of choice
You're looking for the block that contains the string winPEAS; it should be line 265, but if not exactly, it's near there.
Modify the command to the following: `powershell &{{$proc = start-process -filepath C:\\Users\\Public\\${state.folder_name}\\tools\\winPEAS\\winPEASany_ofs.exe -redirectstandardoutput C:\\Windows\\Registration\\CRMLog\\peas.txt -nonewwindow -passthru; $proc | Wait-Process -Timeout 60; $proc | stop-process; echo \"systemInformationDiscovery_1 complete\"}}` (be sure it stays surrounded in quotes)
Save the file, exit the docker container.
Run `docker restart studio sd`

However, that change will get reverted the next time chimera reaches out for an update, which is about every 24h. You can prevent that from happening by overriding the docker tag:
`docker commit studio 10.10.254.1:5000/simspace/chimera-studio:3.12.99`
`docker tag 10.10.254.1:5000/simspace/chimera-studio:3.12.99 10.10.254.1:5000/simspace/chimera-studio:mindflayer_current`
