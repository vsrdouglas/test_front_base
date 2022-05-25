*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application

*** Keywords ***
Add User Dashboard

   Click Element       key=add-employee-dashboard

   Wait For Element    key=add-employee-name

   Input Text          key=add-employee-name      Employee Teste

   Input Text          key=add-employee-email     employee@testee.com

   Input Text          key=add-employee-cost      1000
   
   Click Element       key=add-employee-access

   Wait For Element    semantics=Employee

   Click Element       semantics=Employee

   Input Text          key=add-employee-technologies      C 
   
   Click Element       key=confirm-add-employee

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


View Available Projects by Employee Screen

   Click Element        text=List of Unallocated Employees

   Scroll To Element    text=Employee Teste

   Click Element        text=Employee Teste

   Wait For Element     text=Name:

   Scroll To Element    text=Technologies:

   Click Element        key=assigment-user

   Wait For Element     text=Project Teste

Assign Project to User

   Click Element        text=Project Teste

   Wait For Element     key=addMember-role

   Input Text           key=addMember-role     Dev Master

   Click Element        key=start-date

   Wait For Element    semantics=OK

   Click Element       semantics=OK

   Click Element       semantics=Confirm

   Wait For Element    text=Name:

   Scroll To Element   text=Project Teste

*** Test Cases ***
Should be add a user and project and assign by dashboard

   Add User Dashboard

   Add Project Dashboard

   View Available Projects by Employee Screen

   Assign Project to User
