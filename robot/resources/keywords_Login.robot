*** Settings ***
Resource    ../resources/variables.robot
Resource    ../resources/keywords.robot
Library    RequestsLibrary

*** Keywords ***

TC_005_Login_With_Correct_Credentials
    Myapi
    ${payload}=    Create Dictionary    phone_number=${PHONE}
    ${response}=    POST On Session    myapi    /api/auth/login    json=${payload}
    Status Should Be    200    ${response}
    Should Contain    ${response.json()}    access_token

TC_006_Log in with phone_without_entering_number_phone
    Myapi
    ${payload}=    Create Dictionary
    ${response}=    POST On Session    myapi    /api/auth/login        json=${payload}   expected_status=400
    Status Should Be    400    ${response}
    Should Be Equal   ${response.json()}[error]    Phone number is required

TC_007_Login_With_Unregistered_Phone
    Myapi
    ${payload}=    Create Dictionary    phone_number=0970177070
    ${response}=    POST On Session    myapi    /api/auth/login    json=${payload}    expected_status=400
    Status Should Be    400    ${response}
    Should Be Equal   ${response.json()}[error]    Phone number not registered

TC_008_Login_With_Invalid_Format
    Myapi
    FOR    ${Invalid}    IN    @{Invalid_Format}
        ${payload}=    Create Dictionary    phone_number=${Invalid}
        ${response}=    POST On Session    myapi    /api/auth/login    json=${payload}    expected_status=400
        Status Should Be    400    ${response}
        Should Be Equal   ${response.json()}[error]    Invalid phone number format
    END