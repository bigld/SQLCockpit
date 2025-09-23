# Cadaxo SQL Cokpit 

Install the latest version from transports (https://www.cadaxo.com/public_doc/cockpit/dl/?dl=cockpit.latest)

This commands copy all NPS tranport files in current folder(s recursivly) to you docker container a4h:
```
FOR /R %I IN (K*.NSP) DO docker cp "%I" "a4h:/usr/sap/trans/cofiles/%~nxI"
FOR /R %I IN (R*.NSP) DO docker cp "%I" "a4h:/usr/sap/trans/data/%~nxI"
```

If you only need the Development Version make sure that the main Package **must be** named **/CADAXO/SQLC**

## Original System
To pull the conding without errors make sure to have a clean dev environment

1. Delete ore release all transport requets with cockpit objects  
To avoid tons of popups when deleteing objects from a transport request you can use TX SE03 and option ***Unlock Objects (Expert Tool)***
2. Change the original system of all objets to the local one
   - 1. TX SE03 and option ***Change Object Directory Entries***
   - 2. Search for all objects in package __/CADAXO/SQLC*__
   - 3. Mark all packages with wrong system with F6 or *Edit->Selct Block*
   - 4. Enter **MASS** into the OK-Cokde field (**NO** /n!)
   - 5. Set the Original System and delete the Repair Flag
3. Check you TMS setting
   - 1. TX STMS - Button Transport Routes (Shift+F7)
   - 2. Switch to Change Mode and choose: Edit->Transport Layer->Create: ZNWV - ZNWV 

