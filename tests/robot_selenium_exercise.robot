*** Settings ***
Documentation   A test suite with all the test cases for the Selenium IDE and Robot framework exercise.
...
...             These tests have a workflow that is created using keywords in the 
...             imported resource file.
Library        SeleniumLibrary

*** Variables ***
${EXER_URL}    https://www.saucedemo.com/
${BROWSER}    chrome
${VALID_USER}   standard_user
${LOCKED_USER}    locked_out_user
${PROB_USER}    problem_user
${VALID_PASS}   secret_sauce
${INVALID_PASS}   secret_$auce

*** Test Cases ***
# 1 - Successful user log in
Valid Login 
  Open Browser  ${EXER_URL}    ${BROWSER}
  Maximize Browser Window
  Page Should Contain Element   login-button
  Input Text    user-name    ${VALID_USER}
  Input Password    password     ${VALID_PASS}
  Click Button    login-button
  Element Text Should Be    class:title    PRODUCTS
  [Teardown]    Close Browser

# 2 - Unsuccessful user log in by a locked out user
Invalid Login Locked Out User
  Open Browser  ${EXER_URL}    ${BROWSER}
  Maximize Browser Window
  Page Should Contain Element   login-button
  Input Text    user-name    ${LOCKED_USER}
  Input Password    password     ${VALID_PASS}
  Click Button    login-button
  Page Should Contain   Epic sadface: Sorry, this user has been locked out.
  [Teardown]    Close Browser

# 3 - Typed wrong password
Invalid Password
  Open Browser  ${EXER_URL}    ${BROWSER}
  Maximize Browser Window
  Page Should Contain Element   login-button
  Input Text    user-name    ${VALID_USER}
  Input Password    password     ${INVALID_PASS}
  Click Button    login-button
  Page Should Contain   Epic sadface: Username and password do not match any user in this service
  [Teardown]    Close Browser

# 4 - Logged in as problem user and sees a broken inventory page
Problem User
  Open Browser  ${EXER_URL}    ${BROWSER}
  Maximize Browser Window
  Page Should Contain Element   login-button
  Input Text    user-name    ${PROB_USER}
  Input Password    password     ${VALID_PASS}
  Click Button    login-button
  Page Should Contain   Products
  Click Element   item_5_title_link
  Page Should Contain   ITEM NOT FOUND
  [Teardown]    Close Browser

# 5 - Sort product name (A to Z)