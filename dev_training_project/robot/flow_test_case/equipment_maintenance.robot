*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application


*** Variables ***
${nav_equipment}=  app-equipment-nav
${history_equipment}=  history-equipment
${textFieldMode}=  model-add
${textFieldSerial}=  serial-add
${textFieldProcessor}=  add-processor-equipment
${textFieldMemory}=  add-memory-equipment
${textFieldStorageType}=  add-storageType-equipment
${textFieldStorageSize}=  add-storageSize-equipment
${buttonConfirm}=  confirm-add-equipment

*** Keywords ***
Add Equipment and maintenace

   Click Element       key=${nav_equipment}

   Wait For Element    key=add-equipment

   Click Element       key=add-equipment

   Input Text          key=${textFieldMode}     Dell Teste

   Input Text          key=${textFieldSerial}     dsa5d46sa5da

   Scroll To Element    key=${textFieldProcessor}

   Sleep                4s
   
   Click Element       key=${textFieldProcessor}

   Wait For Element    semantics=Intel I9 teste

   Click Element       semantics=Intel I9 teste

   Scroll To Element    key=${textFieldMemory}
   
   Click Element       key=${textFieldMemory}

   Wait For Element    semantics=16 GB

   Click Element       semantics=16 GB

   Scroll To Element    key=${textFieldStorageType}
   
   Click Element       key=${textFieldStorageType}

   Wait For Element    semantics=HD

   Click Element       semantics=HD

   Click Element       key=${textFieldStorageSize}

   Wait For Element    semantics=1 TB

   Click Element       semantics=1 TB

   Click Element       key=${buttonConfirm}

   Wait For Element    text=Dell Teste

   Click Element       text=Dell Teste

   Wait For Element    semantics=Maintenance

   Click Element       semantics=Maintenance

   Wait For Element    key=add-maintenance

   Click Element       key=add-maintenance

   Wait For Element    text=Add Maintenance

   Input Text          key=add-maintenance-name       Tela quebrada teste

   Click Element       key=add-maintenance-type 

   Wait For Element    semantics=Maintenance

   Click Element       semantics=Maintenance

   Click Element       key=add-maintenance-status

   Wait For Element    semantics=In progress

   Click Element       semantics=In progress

   Click Element       key=add-maintenance-confirm

   Wait For Element    text=Tela quebrada teste

   Click Element       text=Tela quebrada teste

   Wait For Element    key=edit-maintenance

   Click Element       key=edit-maintenance

   Wait For Element    key=edit-field-maintenance

   Input Text          key=edit-field-maintenance     Maintenance Editado

   Click Element       key=edit-maintenance-name

   Wait For Element    text=Maintenance Editado


*** Test Cases ***
Should be able add an equipment and an maintenance and edit the last one

   Add Equipment and maintenace

