*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application

*** Keywords ***
Add Project SearchList

   Click Element       key=app-projects-nav

   Wait For Element    key=add-project-searchlist

   Click Element       key=add-project-searchlist

   Wait For Element    key=add-project-name

   Input Text          key=add-project-name       Project Teste

   Input Text          key=add-project-budget     1000

   Input Text          key=add-project-sprint     10
   
   Click Element       key=add-project-startDate

   Wait For Element    semantics=OK

   Click Element       semantics=OK
   
   Click Element       key=add-project-button

   Wait For Element    text=Project Teste

   Click Element       text=Project Teste

   Wait For Element    text=Project Teste


Edit Project Name

   Click Element       key=edit-project

   Wait For Element    key=edit-name-project

   Input Text          key=edit-name-project       Project Teste Edited

   Click Element       key=edit-status-project

   Wait For Element    semantics=closed

   Click Element       semantics=closed

   Click Element       key=confirm-edit-project

   Wait For Element    semantics=OK

   Click Element       semantics=OK

   Wait For Element    text=Project Teste Edited

Delete Project

   Click Element       key=back-button

   Wait For Element    text=Project Teste Edited

   Click Element       key=delete-project

   Wait For Element    text=Yes

   Click Element       text=Yes

   Wait For Element Absent    text=Project Teste Edited

*** Test Cases ***
Should be able to add project by dashboard

   Add Project SearchList

   Edit Project Name

   Delete Project
