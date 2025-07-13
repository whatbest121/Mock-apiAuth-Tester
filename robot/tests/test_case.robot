*** Settings ***
Library    RequestsLibrary
Resource    ../resources/variables.robot
Resource    ../resources/keywords.robot
Resource    ../resources/keywords_Login.robot
Resource    ../resources/keywords_Register.robot

*** Test Cases ***
Check URL Server
    Myapi
    ${response}=    GET On Session    myapi    /api/health 
    Should Be Equal As Integers    ${response.status_code}    200


E2E Register
    TC_001_Register_With_Correct_Credentials
    TC_002_Register_with_phone_without_entering_number_phone
    TC_003_Register_with_duplicate_phone_number
    TC_004_Register_With_Invalid_Format

E2E Login
    TC_005_Login_With_Correct_Credentials
    TC_006_Log in with phone_without_entering_number_phone
    TC_007_Login_With_Unregistered_Phone
    TC_008_Login_With_Invalid_Format
    
    
    

    