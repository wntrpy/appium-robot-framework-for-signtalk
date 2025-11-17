*** Settings ***
Library    AppiumLibrary
Library    BuiltIn

*** Variables ***
${APP_PACKAGE}       com.example.signtalk
${APP_ACTIVITY}      .MainActivity
${PLATFORM_NAME}     Android
${DEVICE_NAME}       Android Emulator
${MAINTENANCE_ID}    Under Maintenance

*** Test Cases ***
Check Under Maintenance Screen
    [Documentation]                  Passes if the Under Maintenance screen appears on app launch
    Open Application                 http://localhost:4723                                           platformName=${PLATFORM_NAME}    deviceName=${DEVICE_NAME}                               appPackage=${APP_PACKAGE}    appActivity=${APP_ACTIVITY}    automationName=UiAutomator2
    Wait Until Element Is Visible    accessibility_id=${MAINTENANCE_ID}                              timeout=15s
    ${is_displayed}=                 Run Keyword And Return Status                                   Element Should Be Visible        accessibility_id=${MAINTENANCE_ID}
    Close Application
    Run Keyword If                   ${is_displayed}                                                 Log                              Under Maintenance screen is displayed - TEST PASSED
    ...                              ELSE                                                            Fail                             Under Maintenance screen not displayed - TEST FAILED
