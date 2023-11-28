@echo off
:srcds
echo (%time%) srcds started.
start /wait srcds.exe -console -game garrysmod +map nextoren_site19_final +maxplayers 64 +port 27015 +gamemode breach +host_workshop_collection 3044598688
goto srcds
quit