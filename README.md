# ARK: Survival Evolved - Docker Cluster

Docker build for managing an __ARK: Survival Evolved__ server cluster.

This image uses [Ark Server Tools](https://github.com/FezVrasta/ark-server-tools) to manage an ark server and is forked from [boerngen-schmidt/Ark-docker](https://hub.docker.com/r/boerngenschmidt/ark-docker/).

*If you use an old volume, get the new arkmanager.cfg in the template directory.*

__Don't forget to use `docker pull wilco20004/ark_server_v1` to get the latest version of the image__

## Features
 - Easy install (no steamcmd / lib32... to install)
 - Easy access to ark config file
 - Mods handling (via Ark Server Tools)
 - `docker stop` is a clean stop
 - Auto upgrading of arkmanager

# Recommended Usages

## Crontab - Job automation
 You can easily configure automatic update and backup.  
 If you edit the file `/my/path/to/ark/crontab` you can add your crontab job.  
 For example :  
 ```
 # Update the server every hours  
 0 * * * * arkmanager update --warn --update-mods >> /ark/log/crontab.log 2>&1    
 # Backup the server each day at 00:00  `  
 0 0 * * * arkmanager backup >> /ark/log/crontab.log 2>&1
 ```  
 *You can check [this website](http://www.unix.com/man-page/linux/5/crontab/) for more information on cron.*

 After updating the `/my/path/to/ark/crontab` please run the command   
 `docker exec ark crontab -u steam /ark/crontab`

## Simple container
 - First run  
  ```Bash
  docker run -it --name ark \
   -e SESSIONNAME=myserver \
   -e SERVERMAP: "TheIsland" \
   -e ADMINPASSWORD="mypasswordadmin" \
   -p 7778:7778 -p 7778:7778/udp \
   -p 27015:27015 -p 27015:27015/udp \
   -p 32330:32330 \
   -e TZ=UTC \
   -e USER_ID: 1000 \
   -e GROUP_ID: 1000
   -v /my/path/to/ark:/ark \
   -v /my/path/to/cluster:/cluster \
   wilco20004/ark_server_v1
   ```
 - Wait for ark to be downloaded installed and launched, then Ctrl+C to stop the server.
 - Edit */my/path/to/ark/GameUserSetting.ini and Game.ini*
 - Edit */my/path/to/ark/arkserver.cfg* to add mods and configure warning time.
 - Add auto update every day and autobackup by editing */my/path/to/ark/crontab*. [See](#crontab---job-automation)
 - Start the container `docker start ark`
 - Check your server with : `docker exec ark arkmanager status`

## Expose
 + Port : __STEAMPORT__ : Steam port (default: 7778)
 + Port : __SERVERPORT__ : server port (default: 27015)
 + Port : __32330__ : rcon port

## Volumes
+ __/ark__ : Working directory :
    + /ark/server : Server files and data.
    + /ark/log : logs
    + /ark/backup : backups
    + /ark/arkmanager.cfg : config file for Ark Server Tools
    + /ark/crontab : crontab config file
    + /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini : ark Game.ini config file
    + /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSetting.ini : ark GameUserSetting.ini config file
    + /ark/template : Default config files
    + /ark/template/arkmanager.cfg : default config file for Ark Server Tools
    + /ark/template/crontab : default config file for crontab
    + /ark/staging : default directory if you use the --downloadonly option when updating.
+ __/cluster__ : Cluster volume to share with other instances

## Known issues
Currently none
