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
Add Equipment

   Click Element       key=${nav_equipment}

   Wait For Element    key=add-equipment

   Click Element       key=add-equipment

   Input Text          key=${textFieldMode}     Dell Teste

   Input Text          key=${textFieldSerial}     dsa5d46sa5da

   Scroll To Element   key=${textFieldProcessor}

   Sleep                4s
   
   Click Element       key=${textFieldProcessor}

   Wait For Element    semantics=Intel I9 teste

   Click Element       semantics=Intel I9 teste

   Scroll To Element   key=${textFieldMemory}
   
   Click Element       key=${textFieldMemory}

   Wait For Element    semantics=16 GB

   Click Element       semantics=16 GB

   Scroll To Element   key=${textFieldStorageType}
   
   Click Element       key=${textFieldStorageType}

   Wait For Element    semantics=HD

   Click Element       semantics=HD

   Click Element       key=${textFieldStorageSize}

   Wait For Element    semantics=1 TB

   Click Element       semantics=1 TB

   Click Element       key=${buttonConfirm}

   Wait For Element    text=Dell Teste

   Click Element       text=Dell Teste

   Wait For Element    semantics=Assign Equipment

   Click Element       semantics=Assign Equipment

   Wait For Element    text=Admin Test

   Click Element       text=Admin Test

   Wait For Element    semantics=OK

   Click Element       semantics=OK

   Wait For Element    semantics=Close Assignment

   Wait For Element    key=${history_equipment}

   Click Element       key=${history_equipment}

   Wait For Element    text=Admin Test

   Click Element       semantics=Close Assignment

   Wait For Element    semantics=OK

   Click Element       semantics=OK

   Wait For Element    semantics=Assign Equipment

*** Test Cases ***
Should be able add and assign equipment to an user

   Add Equipment
