*** Settings ***
Library    AppiumLibrary

*** Variables ***
${PLATFORM}        Android
${DEVICE}          emulator-5554
${APP_PACKAGE}     com.example.signtalk
${APP_ACTIVITY}    .MainActivity

# --- Locators ---
${LOGIN_GOOGLE_XPATH}            //android.widget.ImageView[@content-desc="Log in with Google"]
${GOOGLE_FIRST_ACCOUNT_XPATH}    (//android.widget.LinearLayout[@resource-id="com.google.android.gms:id/container"])[1]
${HOME_USER_ACCESSIBILITY_ID}    moses\nHello 🙂👍 #sign\n2:31 AM

# --- Notification Permission Modal XPaths ---
${NOTIF_DIALOG_XPATH}    //android.widget.LinearLayout[@resource-id="com.android.permissioncontroller:id/grant_dialog"]
${ALLOW_BUTTON_XPATH}    //android.widget.Button[@resource-id="com.android.permissioncontroller:id/permission_allow_button"]


*** Test Cases ***
Login With Google Should Reach Home
    [Documentation]    Log in with Google and verify the home screen is visible.

    # --- Open App ---
    Open Application    http://localhost:4723
    ...                 platformName=${PLATFORM}
    ...                 deviceName=${DEVICE}
    ...                 automationName=UiAutomator2
    ...                 appPackage=${APP_PACKAGE}
    ...                 appActivity=${APP_ACTIVITY}
    ...                 newCommandTimeout=300


    # --- Handle notification permission (before login) ---
    ${dialog_present}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${NOTIF_DIALOG_XPATH}        8s
    Run Keyword If        ${dialog_present}                Click Element                    xpath=${ALLOW_BUTTON_XPATH}
    Run Keyword If        ${dialog_present}                Log                              Notification permission allowed


    # --- Login with Google ---
    Wait Until Element Is Visible    xpath=${LOGIN_GOOGLE_XPATH}    20s
    Click Element                    xpath=${LOGIN_GOOGLE_XPATH}

    Wait Until Element Is Visible    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}    20s
    Click Element                    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}


    # --- Handle permission modal (after choosing account) ---
    ${dialog_present2}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${NOTIF_DIALOG_XPATH}              8s
    Run Keyword If         ${dialog_present2}               Click Element                    xpath=${ALLOW_BUTTON_XPATH}
    Run Keyword If         ${dialog_present2}               Log                              Permission allowed after Google login


    # --- Verify home screen ---
    Wait Until Element Is Visible    accessibility_id=${HOME_USER_ACCESSIBILITY_ID}    25s
    Log                              Home screen is visible — test PASSED

    # --- Close App ---
    Close Application
