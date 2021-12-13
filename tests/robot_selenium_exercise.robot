*** Settings ***
Documentation   A test suite with all the test cases for the Selenium IDE and Robot framework exercise.
...
...             These tests have a workflow that is created using keywords in the 
...             imported resource file.
Library        SeleniumLibrary
Library        Collections

*** Variables ***
${EXER_URL}    https://www.saucedemo.com/
${BROWSER}    chrome
${VALID_USER}   standard_user
${LOCKED_USER}    locked_out_user
${PROB_USER}    problem_user
${VALID_PASS}   secret_sauce
${INVALID_PASS}   secret_$auce
@{azList}
  ...  Sauce Labs Backpack
  ...  Sauce Labs Bike Light
  ...  Sauce Labs Bolt T-Shirt
  ...  Sauce Labs Fleece Jacket
  ...  Sauce Labs Onesie
  ...  Test.allTheThings() T-Shirt (Red)
@{zaList}
  ...  Test.allTheThings() T-Shirt (Red)
  ...  Sauce Labs Onesie
  ...  Sauce Labs Fleece Jacket
  ...  Sauce Labs Bolt T-Shirt
  ...  Sauce Labs Bike Light
  ...  Sauce Labs Backpack

@{descPriceList}
  ...  $49.99
  ...  $29.99
  ...  $15.99
  ...  $15.99
  ...  $9.99
  ...  $7.99

@{ascPriceList}
  ...  $7.99
  ...  $9.99
  ...  $15.99
  ...  $15.99
  ...  $29.99
  ...  $49.99

*** Keywords ***
SORT_AZ
  ${index}=   Set Variable    0
  ${products}=    Get WebElements   class:inventory_item_name
  FOR   ${item}   IN    @{products}
    ${curItem}=   Get From List   ${azList}   ${index}
    Should Be Equal   ${item.text}   ${curItem}
    ${index}=   Evaluate    ${index}+1
  END

SORT_ZA
  ${index}=   Set Variable    0
  ${products}=    Get WebElements   class:inventory_item_name
  FOR   ${item}   IN    @{products}
    ${curItem}=   Get From List   ${zaList}   ${index}
    Should Be Equal   ${item.text}   ${curItem}
    ${index}=   Evaluate    ${index}+1
  END

SORT_ASC
  ${index}=   Set Variable    0
  ${products}=    Get WebElements   class:inventory_item_price
  FOR   ${item}   IN    @{products}
    ${curItem}=   Get From List   ${ascPriceList}   ${index}
    Should Be Equal   ${item.text}   ${curItem}
    ${index}=   Evaluate    ${index}+1
  END

SORT_DESC
  ${index}=   Set Variable    0
  ${products}=    Get WebElements   class:inventory_item_price
  FOR   ${item}   IN    @{products}
    ${curItem}=   Get From List   ${descPriceList}   ${index}
    Should Be Equal   ${item.text}   ${curItem}
    ${index}=   Evaluate    ${index}+1
  END
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
Alphabetically Sort Product Names
  Open Browser  ${EXER_URL}    ${BROWSER}
  Maximize Browser Window
  Page Should Contain Element   login-button
  Input Text    user-name    ${VALID_USER}
  Input Password    password     ${VALID_PASS}
  Click Button    login-button
  Page Should Contain   Products
  Select From List By Value  class:product_sort_container  az
  SORT_AZ
  [Teardown]  Close Browser

# 6 - Sort product name (Z to A)
Reverse Alphabetically Sort Product Names
  Open Browser  ${EXER_URL}    ${BROWSER}
  Maximize Browser Window
  Page Should Contain Element   login-button
  Input Text    user-name    ${VALID_USER}
  Input Password    password     ${VALID_PASS}
  Click Button    login-button
  Page Should Contain   Products
  Select From List By Value    class:product_sort_container    za
  SORT_ZA
  [Teardown]  Close Browser

# 7 - Sort product price (low to high)
Ascending Product Prices
  Open Browser  ${EXER_URL}    ${BROWSER}
  Maximize Browser Window
  Page Should Contain Element   login-button
  Input Text    user-name    ${VALID_USER}
  Input Password    password     ${VALID_PASS}
  Click Button    login-button
  Page Should Contain   Products
  Select From List By Value    class:product_sort_container    lohi
  SORT_ASC
  [Teardown]  Close Browser

# 8 - Sort product price (high to low)
Ascending Product Prices
  Open Browser  ${EXER_URL}    ${BROWSER}
  Maximize Browser Window
  Page Should Contain Element   login-button
  Input Text    user-name    ${VALID_USER}
  Input Password    password     ${VALID_PASS}
  Click Button    login-button
  Page Should Contain   Products
  Select From List By Value    class:product_sort_container    hilo
  SORT_DESC
  [Teardown]  Close Browser