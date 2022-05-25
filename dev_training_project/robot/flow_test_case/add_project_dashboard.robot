*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application

*** Keywords ***
Add Project Dashboard

   Click Element       key=add-project-dashboard-app

   Wait For Element    key=add-project-name

   Input Text          key=add-project-name       Project Teste

   Input Text          key=add-project-budget     1000

   Input Text          key=add-project-sprint     10
   
   Click Element       key=add-project-startDate

   Wait For Element    semantics=OK

   Click Element       semantics=OK
   
   Click Element       key=add-project-button

   Wait For Element    key=app-projects-nav

   Click Element       key=app-projects-nav

   Wait For Element    text=Project Teste

   Click Element       text=Project Teste

   Wait For Element    text=Project Teste

*** Test Cases ***
Should be add project by dashboard

   Add Project Dashboard
