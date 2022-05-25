*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application

*** Keywords ***
Delete and add Processor

   Click Element     key=icon-button-drawer

   Wait For Element  text=Equipments Parameters

   Click Element     text=Equipments Parameters

   Wait For Element  type=ListView

   Click Element     key=delete-parameters0

   Wait For Element  text=Yes

   Click Element     text=Yes

   Wait For Element  key=add-button

   Click Element     key=add-button

   Wait For Element  key=add-processor

   Input Text        key=add-processor    Inteste I9

   Click Element     text=Confirm

   Wait For Element  text=Inteste I9
 
   Click Element     key=edit-parameters0

   Wait For Element  key=add-processor

   Input Text        key=add-processor    Intel I9

   Click Element     text=Confirm

   Wait For Element  text=Intel I9

*** Test Cases ***
Should delete, add and edit an processor
   
   Delete and add Processor