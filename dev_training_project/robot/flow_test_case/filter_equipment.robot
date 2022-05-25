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
Add Processor

   Click Element     key=icon-button-drawer

   Wait For Element  text=Equipments Parameters

   Click Element     text=Equipments Parameters

   Wait For Element  type=ListView

   Click Element     key=add-button

   Wait For Element  key=add-processor

   Input Text        key=add-processor   Intel Filter

   Click Element     text=Confirm

   Wait For Element  text=Intel Filter

   Click Element     key=back-button

   Wait For Element  key=icon-button-drawer

   Click Element     key=close-menu

Add Equipment Um

   Click Element       key=${nav_equipment}

   Wait For Element    key=add-equipment

   Click Element       key=add-equipment

   Input Text          key=${textFieldMode}     Dell Teste

   Input Text          key=${textFieldSerial}     dsa5d46sa5da

   Scroll To Element   key=${textFieldProcessor}

   Sleep               4s
   
   Click Element       key=${textFieldProcessor}

   Wait For Element    semantics=Intel I9 teste

   Click Element       semantics=Intel I9 teste

   Scroll To Element    key=${textFieldMemory}
   
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

Add Equipment Dois

   Click Element       key=add-equipment

   Input Text          key=${textFieldMode}     Dell Teste Filter

   Input Text          key=${textFieldSerial}     dsals13bm

   Scroll To Element   key=${textFieldProcessor}

   Sleep               4s
   
   Click Element       key=${textFieldProcessor}

   Wait For Element    semantics=Intel Filter

   Click Element       semantics=Intel Filter

   Scroll To Element    key=${textFieldMemory}
   
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

   Wait For Element    text=Dell Teste Filter

Filter Equipment

   Click Element       key=filter-icon

   Wait For Element    text=Intel Filter

   Click Element       text=Intel Filter

   Click Element       text=Confirm

   Wait For Element Absent    text=Dell Teste
   
*** Test Cases ***
Should add processor, add two equipments and filter
   
   Add Processor

   Add Equipment Um

   Add Equipment Dois

   Filter Equipment
