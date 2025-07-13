*** Settings ***
Resource    ../resources/variables.robot
Resource    ../resources/keywords.robot
Library    RequestsLibrary

*** Keywords ***

TC_001_Register_With_Correct_Credentials
    Myapi
    ${payload}=    Create Dictionary    phone_number=${PHONE}
    ${response}=    POST On Session    myapi    /api/auth/register    json=${payload}
    Status Should Be    200    ${response}
    Should Be Equal    ${response.json()}[message]    Registration successful
    ${id}    Set Variable    ${response.json()}[user_id]
    ${response}=    GET On Session    myapi    /api/auth/${id}
    Status Should Be    200    ${response}
    Should Be Equal    ${response.json()}[phone_number]    ${PHONE}
    Should Be Equal    ${response.json()}[status]    active

TC_002_Register_with_phone_without_entering_number_phone
    Myapi
    ${payload}=    Create Dictionary
    ${response}=    POST On Session    myapi    /api/auth/register       json=${payload}   expected_status=400
    Status Should Be    400    ${response}
    Should Be Equal   ${response.json()}[error]    Phone number is required

TC_003_Register_with_duplicate_phone_number
    Myapi
    ${payload}=    Create Dictionary    phone_number=${PHONE}
    ${response}=    POST On Session    myapi    /api/auth/register    json=${payload}    expected_status=400
    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()}[error]    Phone number already exists

TC_004_Register_With_Invalid_Format
    Myapi
    FOR    ${Invalid}    IN    @{Invalid_Format}
        ${payload}=    Create Dictionary    phone_number=${Invalid}
        ${response}=    POST On Session    myapi    /api/auth/register    json=${payload}    expected_status=400
        Status Should Be    400    ${response}
        Should Be Equal   ${response.json()}[error]    Invalid phone number format
    END
