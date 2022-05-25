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



Generate Report

    Click Element       key=app-report-nav

    Wait For Element    text=Project Teste

    Click Element       text=Project Teste

    Wait For Element    key=forecast-button

    Click Element       key=forecast-button

    Wait For Element    text=Select the Number of Sprints

    Input Text          key=sprints-quant  5

    Click Element       text=Confirm

    Wait For Element    key=forecast-cancel-button

    Click Element       key=forecast-cancel-button

*** Test Cases ***
Should generate a report and a forecast

   Add Project SearchList

   Generate Report
