*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application

*** Keywords ***
Delete and add Memory

   Click Element     key=icon-button-drawer

   Wait For Element  text=Equipments Parameters

   Click Element     text=Equipments Parameters

   Wait For Element  type=ListView

   Click Element     key=dropdown-parameters

   Wait For Element  semantics=Memory

   Click Element     semantics=Memory

   Wait For Element  type=ListView

   Click Element     key=delete-parameters0

   Wait For Element  text=Yes

   Click Element     text=Yes

   Wait For Element  key=add-button

   Click Element     key=add-button

   Wait For Element  key=add-size-memory

   Input Text        key=add-size-memory    64

   Click Element     key=add-unit-memory

   Wait For Element  semantics=TB

   Click Element     semantics=TB

   Click Element     text=Confirm

   Wait For Element  text=64 TB
 
   Click Element     key=edit-parameters0

   Wait For Element  key=add-size-memory

   Input Text        key=add-size-memory    32

   Click Element     key=add-unit-memory

   Wait For Element  semantics=GB

   Click Element     semantics=GB

   Click Element     text=Confirm

   Wait For Element  text=32 GB

*** Test Cases ***
Should delete, add and edit an memory
   
   Delete and add Memory
