*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application

*** Variables ***
${buttonConfirm}=  confirm-add-equipment

*** Keywords ***
Add Equipment SearchList

   Click Element       key=app-equipment-nav

   Wait For Element    key=add-equipment

   Click Element       key=add-equipment

   Wait For Element    key=model-add

   Input Text          key=model-add              Dell Teste

   Input Text          key=serial-add             dsanjds12321n

   Scroll To Element   key=add-processor-equipment

   Sleep               4s

   Click Element       key=add-processor-equipment
   
   Wait For Element    semantics=Intel I9 teste

   Click Element       semantics=Intel I9 teste

   Click Element       key=add-memory-equipment
   
   Wait For Element    semantics=16 GB

   Click Element       semantics=16 GB

   Click Element       key=add-storageType-equipment
   
   Wait For Element    semantics=HD

   Click Element       semantics=HD

   Click Element       key=add-storageSize-equipment
   
   Wait For Element    semantics=1 TB

   Click Element       semantics=1 TB

   Click Element       key=${buttonConfirm}

   Wait For Element    text=Dell Teste

   Click Element       text=Dell Teste

   Wait For Element    text=Dell Teste


Edit Equipment Name

   Click Element       key=edit-equipments-history

   Wait For Element    key=model-edit

   Input Text          key=model-edit        Dell Teste Edited
   
   Input Text          key=serial-edit       dsadksaljdsails

   Input Text          key=cost-edit         2135

   Scroll To Element   key=processor-equipment-edit

   Sleep               4s

   Click Element       key=processor-equipment-edit
   
   Wait For Element    semantics=Intel I7 teste

   Click Element       semantics=Intel I7 teste

   Click Element       key=memory-equipment-edit
   
   Wait For Element    semantics=8 GB

   Click Element       semantics=8 GB

   Click Element       key=storagetype-equipment-edit
   
   Wait For Element    semantics=SSD

   Click Element       semantics=SSD

   Click Element       key=storageSize-equipment-edit
   
   Wait For Element    semantics=500 GB

   Click Element       semantics=500 GB

   Click Element       text=Confirm

   Wait For Element    text=Dell Teste Edited

Delete Equipment

   Click Element       key=back-button

   Wait For Element    text=Dell Teste Edited

   Click Element       key=delete-equipment

   Wait For Element    text=Yes

   Click Element       text=Yes

   Wait For Element Absent    text=Dell Teste Edited


*** Test Cases ***
Should be able to add equipment and edit

   Add Equipment SearchList

   Edit Equipment Name

   Delete Equipment
