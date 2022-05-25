*** Settings ***
Library  AppiumFlutterLibrary
Resource         ./../main.robot
Test Setup       Log in as Admin
Test Teardown    Close Application


*** Variables ***
${input_user}=  admin@admin.com
${input_password}=  123456

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

   Click Element        text=List of Unallocated Employees

   Scroll To Element    text=Employee Teste

   Click Element        text=Employee Teste

   Wait For Element     text=Name:



*** Test Cases ***
Should be able to log in

   Add User Dashboard
