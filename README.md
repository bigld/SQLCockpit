# Cadaxo SQL Cokpit 

Install the latest version from transports (https://www.cadaxo.com/public_doc/cockpit/dl/?dl=cockpit.latest)

If you only need the Development Version make sure that the main Package **must be** named **/CADAXO/SQLC**

## Original System
To pull the conding without errors make shure tho have a clean dev environment

1. Delete ore release all transport requets with cockpit objects
To avoid tons of popups when deleteing onjects from a transport request you can use TX SE03 and option ***Unlock Objects (Expert Tool)***
2. Change the original system of all objets to the local one
TX SE03 and option ***Change Object Directory Entries***
Search fro all objects in package __/CADAXO/SQLC*__
Mark all packages with wrong system with F6 or *Edit->Selct Block*
Enter **MASS** into the OK-Cokde field (**NO** /n!)
Set the Original System and delete the Repair Flag
4.


