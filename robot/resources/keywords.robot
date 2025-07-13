*** Settings ***
Library    RequestsLibrary
Resource    ../resources/variables.robot

*** Keywords ***
Myapi
     Create Session    myapi    ${BASE_URL}

