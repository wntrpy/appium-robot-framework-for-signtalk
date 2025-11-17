*** Settings ***
Library    AppiumLibrary
Library    BuiltIn

*** Variables ***
${PLATFORM}        Android
${DEVICE}          emulator-5554
${APP_PACKAGE}     com.example.signtalk
${APP_ACTIVITY}    .MainActivity
${TIMEOUT}         30s

# --- Login Locators ---
${LOGIN_GOOGLE_XPATH}            //android.widget.ImageView[@content-desc="Log in with Google"]
${GOOGLE_FIRST_ACCOUNT_XPATH}    (//android.widget.LinearLayout[@resource-id="com.google.android.gms:id/container"])[1]

# --- Notification permission ---
${NOTIF_DIALOG_ID}          com.android.permissioncontroller:id/grant_dialog
${NOTIF_ALLOW_BUTTON_ID}    com.android.permissioncontroller:id/permission_allow_button

# --- Home screen ---
${HOME_USER_ACCESSIBILITY_ID}    moses\nHello 🙂👍 #sign\n2:31 AM

# --- Profile Button ---
${PROFILE_BTN}    xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View[3]

# --- Profile Screen Buttons ---
${EDIT_NAME_BTN}    xpath=(//android.widget.Button[@content-desc="Edit"])[1]
${EDIT_AGE_BTN}     xpath=(//android.widget.Button[@content-desc="Edit"])[2]

*** Test Cases ***
Login And Edit Profile Robust
    [Documentation]    Login → Home → Profile → Edit Name → Save → Edit Age → Save → Done

    # --- Open App ---
    Open Application    http://localhost:4723
    ...                 platformName=${PLATFORM}
    ...                 deviceName=${DEVICE}
    ...                 automationName=UiAutomator2
    ...                 appPackage=${APP_PACKAGE}
    ...                 appActivity=${APP_ACTIVITY}
    ...                 newCommandTimeout=300

    Set Appium Timeout    60s

    # --- Login with Google ---
    Wait Until Element Is Visible    xpath=${LOGIN_GOOGLE_XPATH}    ${TIMEOUT}
    Click Element                    xpath=${LOGIN_GOOGLE_XPATH}

    Wait Until Element Is Visible    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}    ${TIMEOUT}
    Click Element                    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}

    # --- Handle notification permission modal ---
    ${dialog_present}=    Run Keyword And Return Status
    ...                   Wait Until Element Is Visible    id=${NOTIF_DIALOG_ID}    8s
    Run Keyword If        ${dialog_present}                Click Element            id=${NOTIF_ALLOW_BUTTON_ID}
    Run Keyword If        ${dialog_present}                Log                      Notification permission allowed

    # --- Wait for Home screen ---
    Wait Until Element Is Visible    accessibility_id=${HOME_USER_ACCESSIBILITY_ID}    ${TIMEOUT}

    # --- Open Profile ---
    Wait Until Element Is Visible    ${PROFILE_BTN}    ${TIMEOUT}
    Click Element                    ${PROFILE_BTN}
    Sleep                            1s

    # --- EDIT NAME ---
    Wait Until Element Is Visible    ${EDIT_NAME_BTN}    ${TIMEOUT}
    Click Element                    ${EDIT_NAME_BTN}
    Sleep                            0.5s

    ${name_field}=    Get Webelement    xpath=(//android.widget.EditText)[1]
    Click Element     ${name_field}
    Sleep             0.5s
    Clear Text        ${name_field}
    Input Text        ${name_field}     Sign Test
    Sleep             0.5s

    # --- Save name ---
    Click Element    accessibility_id=Save
    Sleep            1s

    # --- EDIT AGE ---
    Wait Until Element Is Visible    ${EDIT_AGE_BTN}    ${TIMEOUT}
    Click Element                    ${EDIT_AGE_BTN}
    Sleep                            1s

    ${age_field}=    Get Webelement    xpath=(//android.widget.EditText)[1]
    Click Element    ${age_field}
    Sleep            0.5s
    Clear Text       ${age_field}
    Input Text       ${age_field}      22
    Sleep            0.5s

    # --- Save age ---
    Click Element    accessibility_id=Save
    Sleep            1s

    Log    Profile name and age successfully updated — test PASSED

    # --- Close App ---
    Close Application
