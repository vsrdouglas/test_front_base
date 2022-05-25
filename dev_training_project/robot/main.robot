*** Settings ***
Library  AppiumFlutterLibrary
Library  RequestsLibrary

# Test Timeout    50 seconds

*** Variables ***
${input_user}=  admin@admin.com
${input_password}=  123456

*** Keywords ***
Log in as Admin

   ${response}=    GET  https://project-manager-front-test.herokuapp.com/api/v1/users/test/setup

   Open Application    http://localhost:4723/wd/hub
   ...                 automationName=flutter
   ...                 platformName=Android
   ...                 deviceName=robot_29
   ...                 app=C:/DouglasGit/front pm/dev-training-fe/dev_training_project/build/app/outputs/apk/dev/debug/app-dev-debug.apk
   # C:/DouglasGit/front pm/dev-training-fe/dev_training_project/build/app/outputs/apk/dev/debug/app-dev-debug.apk
   #C:/Users/Tunts/development/projects/dev-training-fe/dev_training_project/build/app/outputs/apk/dev/debug/app-dev-debug.apk
   ...                 udid=emulator-5554
   
   Wait For Element    key=email-text-field      200
   
   Input Text          key=email-text-field      ${input_user}

   Input Text          key=password-text-field  ${input_password}

   Click Element       key=btn-sign-in

   Wait For Element    key=info-dashboard-app      60