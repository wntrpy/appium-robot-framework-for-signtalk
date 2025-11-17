*** Settings ***
Library    AppiumLibrary

*** Variables ***
${PLATFORM}        Android
${DEVICE}          emulator-5554
${APP_PACKAGE}     com.example.signtalk
${APP_ACTIVITY}    .MainActivity

${EMAIL}    marmildez03@gmail.com

# --- Forgot Password Locators ---
${FORGOT_PASS_ACCESS_ID}      Forgot Password?
${EMAIL_EDITTEXT_CLASS}       android.widget.EditText
${SUBMIT_BUTTON_ACCESS_ID}    SUBMIT
${SUCCESS_DIALOG_XPATH}       //android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View

# --- Notification Permission Modal XPaths ---
${NOTIF_DIALOG_XPATH}    //android.widget.LinearLayout[@resource-id="com.android.permissioncontroller:id/grant_dialog"]
${ALLOW_BUTTON_XPATH}    //android.widget.Button[@resource-id="com.android.permissioncontroller:id/permission_allow_button"]


*** Test Cases ***
Forgot Password - Successful Reset
    [Documentation]    Click Forgot Password, enter valid email, submit, and verify success dialog.

    # --- Open App ---
    Open Application    http://localhost:4723
    ...                 platformName=${PLATFORM}
    ...                 deviceName=${DEVICE}
    ...                 automationName=UiAutomator2
    ...                 appPackage=${APP_PACKAGE}
    ...                 appActivity=${APP_ACTIVITY}
    ...                 newCommandTimeout=300

    # --- Handle notification permission if it appears ---
    ${notif_present}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${NOTIF_DIALOG_XPATH}        8s
    Run Keyword If       ${notif_present}                 Click Element                    xpath=${ALLOW_BUTTON_XPATH}
    Run Keyword If       ${notif_present}                 Log                              Notification permission allowed


    # --- Wait for Forgot Password button ---
    Wait Until Element Is Visible    accessibility_id=${FORGOT_PASS_ACCESS_ID}    15s

    # --- Click Forgot Password button ---
    Click Element    accessibility_id=${FORGOT_PASS_ACCESS_ID}

    # --- Wait for EditText in Forgot Password page ---
    Wait Until Element Is Visible    class=${EMAIL_EDITTEXT_CLASS}    10s

    # --- Tap the email field ---
    Click Element    class=${EMAIL_EDITTEXT_CLASS}

    # --- Enter Email ---
    Input Text    class=${EMAIL_EDITTEXT_CLASS}    ${EMAIL}

    # --- Click SUBMIT ---
    Click Element    accessibility_id=${SUBMIT_BUTTON_ACCESS_ID}

    # --- Verify Success Dialog Appears ---
    ${dialog_present}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${SUCCESS_DIALOG_XPATH}    10s

    Run Keyword If    ${dialog_present}        Log     Success dialog appeared — test PASSED
    Run Keyword If    not ${dialog_present}    Fail    Success dialog did NOT appear — test FAILED

    # --- Close App ---
    Close Application
