*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application

*** Keywords ***
Delete Storage and Add Storage

   Click Element     key=icon-button-drawer

   Wait For Element  text=Equipments Parameters

   Click Element     text=Equipments Parameters

   Wait For Element  type=ListView

   Click Element     key=dropdown-parameters

   Wait For Element  semantics=Storage

   Click Element     semantics=Storage

   Wait For Element  type=ListView

   Click Element     key=delete-parameters0

   Wait For Element  text=Yes

   Click Element     text=Yes

   Wait For Element  key=add-button

   Click Element     key=add-button

   Wait For Element  key=storage-type

   Click Element     key=storage-type

   Wait For Element  semantics=HD

   Click Element     semantics=HD

   Input Text        key=storage-size    500

   Click Element     key=storage-unit

   Wait For Element  semantics=TB

   Click Element     semantics=TB

   Click Element     text=Confirm

   Wait For Element  text=500 TB
 
   Click Element     key=edit-parameters0

   Wait For Element  key=storage-type

   Click Element     key=storage-type

   Wait For Element  semantics=SSD

   Click Element     semantics=SSD

   Input Text        key=storage-size    264

   Click Element     key=storage-unit

   Wait For Element  semantics=GB

   Click Element     semantics=GB

   Click Element     text=Confirm

   Wait For Element  text=264 GB

*** Test Cases ***
Should delete, add and edit an storage
   
   Delete Storage and Add Storage
