*** Settings ***
Library    AppiumLibrary

*** Variables ***
${PLATFORM}        Android
${DEVICE}          emulator-5554
${APP_PACKAGE}     com.example.signtalk
${APP_ACTIVITY}    .MainActivity

# --- Login Page Locators ---
${EMAIL_FIELD_XPATH}         //android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.EditText[1]
${PASSWORD_FIELD_XPATH}      //android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.EditText[2]
${LOGIN_BUTTON_ACCESS_ID}    Login
${ERROR_TEXT_XPATH}          (//android.view.View[@content-desc="Email or password is incorrect. 2 attempts remaining."])[1]

# --- Permission Modal Locators ---
${PERMISSION_DIALOG_XPATH}    //android.widget.LinearLayout[@resource-id="com.android.permissioncontroller:id/grant_dialog"]
${PERMISSION_ALLOW_BUTTON}    //android.widget.Button[@resource-id="com.android.permissioncontroller:id/permission_allow_button"]


*** Keywords ***
Handle Notification Permission
    ${popup}=         Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${PERMISSION_DIALOG_XPATH}    5s
    Run Keyword If    ${popup}                         Click Element                    xpath=${PERMISSION_ALLOW_BUTTON}
    Run Keyword If    ${popup}                         Log                              Notification permission allowed


*** Test Cases ***
Login With Correct Email Should Show Error
    [Documentation]    Attempt login with correct email and dummy password, verify error appears.

    # --- Open App ---
    Open Application    http://localhost:4723
    ...                 platformName=${PLATFORM}
    ...                 deviceName=${DEVICE}
    ...                 automationName=UiAutomator2
    ...                 appPackage=${APP_PACKAGE}
    ...                 appActivity=${APP_ACTIVITY}
    ...                 newCommandTimeout=300

    # --- Handle splash + notification permission modal ---
    Sleep                             2s
    Handle Notification Permission

    # --- Input correct email ---
    Wait Until Element Is Visible    xpath=${EMAIL_FIELD_XPATH}    15s
    Click Element                    xpath=${EMAIL_FIELD_XPATH}
    Input Text                       xpath=${EMAIL_FIELD_XPATH}    marmildez03@gmail.com

    # --- Input dummy password ---
    Wait Until Element Is Visible    xpath=${PASSWORD_FIELD_XPATH}    10s
    Click Element                    xpath=${PASSWORD_FIELD_XPATH}
    Input Text                       xpath=${PASSWORD_FIELD_XPATH}    WrongPass123!

    # --- Click login button ---
    Click Element    accessibility_id=${LOGIN_BUTTON_ACCESS_ID}

    # --- Verify error message ---
    ${error_present}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${ERROR_TEXT_XPATH}                     10s
    Run Keyword If       ${error_present}                 Log                              Error message appeared — test PASSED
    Run Keyword If       not ${error_present}             Fail                             Error message did not appear — test FAILED

    # --- Close App ---
    Close Application
