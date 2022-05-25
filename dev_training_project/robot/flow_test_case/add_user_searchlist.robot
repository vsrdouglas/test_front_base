*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application

*** Keywords ***
Add User SearchList

   Click Element       key=app-employees-nav

   Wait For Element    key=employee-search-list

   Click Element       key=add-user-button

   Wait For Element    key=add-employee-name

   Input Text          key=add-employee-name      Employee Teste

   Input Text          key=add-employee-email     employee@testee.com

   Input Text          key=add-employee-cost      1000
   
   Click Element       key=add-employee-access

   Wait For Element    semantics=Employee

   Click Element       semantics=Employee

   Input Text          key=add-employee-technologies      C 
   
   Click Element       key=confirm-add-employee

View and Edit Employee

   Wait For Element    text=Employee Teste

   Click Element       text=Employee Teste

   Wait For Element    text=Name:

   Click Element       key=edit-name-employee

   Wait For Element    key=fieldEdit

   Input Text          key=fieldEdit       Employee Teste Edited

   Click Element       key=confirmEditEmployee

   Wait For Element    text=Employee Teste Edited

   Click Element       key=edit-email-employee
   
   Wait For Element    key=fieldEdit

   Input Text          key=fieldEdit        testeedit@admin.com

   Click Element       key=confirmEditEmployee

   Wait For Element    text=testeedit@admin.com
   
   Click Element       key=edit-role-employee

   Wait For Element    key=select-level-dropdown

   Click Element       key=select-level-dropdown

   Click Element       semantics=RH
   
   Click Element       semantics=Yes

   Wait For Element    text=rh

   Click Element       key=edit-cost-employee

   Wait For Element    key=fieldEdit

   Input Text          key=fieldEdit        2011

   Click Element       key=confirmEditEmployee

   Wait For Element    text=R$2011.00

   Scroll To Element   key=editTechnologies

   Click Element       key=editTechnologies

   Wait For Element    key=fieldEdit

   Input Text          key=fieldEdit        C, Flutter

   Click Element       key=confirmEditEmployee

   Wait For Element    text=C, Flutter

Revoke Access and Return Access
   
   Click Element       key=text-revoke-access

   Wait For Element    semantics=Yes

   Click Element       semantics=Yes

   Wait For Element    text=Return Access

   Click Element       semantics=Return Access

   Wait For Element    key=text-revoke-access

Delete Employee

   Click Element       key=back-button

   Wait For Element    text=Employee Teste Edited

   Click Element       key=delete-employee1

   Wait For Element    text=Yes

   Click Element       text=Yes

   Wait For Element Absent    text=Employee Teste Edited

*** Test Cases ***
Should be add user and edit by searchlist

   Add User SearchList

   View and Edit Employee

   Revoke Access and Return Access

   Delete Employee
