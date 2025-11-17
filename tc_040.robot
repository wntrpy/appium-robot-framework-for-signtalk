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

# Notification permission
${NOTIF_DIALOG_ID}          com.android.permissioncontroller:id/grant_dialog
${NOTIF_ALLOW_BUTTON_ID}    com.android.permissioncontroller:id/permission_allow_button

# Home screen
${HOME_USER_ACCESSIBILITY_ID}    moses\nHello 🙂👍 #sign\n2:31 AM

# Search button on Home
${SEARCH_BTN}    accessibility_id=Search contact...

# Search bar
${SEARCH_BAR}    class=android.widget.EditText

# User card
${USER_CARD}    accessibility_id=Moses Armildez\narmildezmoses11olpstem@gmail.com

*** Test Cases ***
Search User And Verify
    [Documentation]    Login → Home → Search → Input Name → Verify User Appears

    # --- Open App ---
    Open Application    http://localhost:4723
    ...                 platformName=${PLATFORM}
    ...                 deviceName=${DEVICE}
    ...                 automationName=UiAutomator2
    ...                 appPackage=${APP_PACKAGE}
    ...                 appActivity=${APP_ACTIVITY}
    ...                 newCommandTimeout=300

    Set Appium Timeout    60s

    # --- Handle notification modal immediately if it appears ---
    ${modal_start}=    Run Keyword And Return Status
    ...                Wait Until Element Is Visible    id=${NOTIF_DIALOG_ID}    5s
    Run Keyword If     ${modal_start}                   Click Element            id=${NOTIF_ALLOW_BUTTON_ID}
    Run Keyword If     ${modal_start}                   Log                      Permission allowed on app start

    # --- Login with Google ---
    Wait Until Element Is Visible    xpath=${LOGIN_GOOGLE_XPATH}    ${TIMEOUT}
    Click Element                    xpath=${LOGIN_GOOGLE_XPATH}

    Wait Until Element Is Visible    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}    ${TIMEOUT}
    Click Element                    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}

    # --- Handle notification modal again (sometimes appears after Google login) ---
    ${modal_after_login}=    Run Keyword And Return Status
    ...                      Wait Until Element Is Visible    id=${NOTIF_DIALOG_ID}    8s
    Run Keyword If           ${modal_after_login}             Click Element            id=${NOTIF_ALLOW_BUTTON_ID}
    Run Keyword If           ${modal_after_login}             Log                      Permission allowed after Google login

    # --- Wait for Home screen ---
    Wait Until Element Is Visible    accessibility_id=${HOME_USER_ACCESSIBILITY_ID}    ${TIMEOUT}

    # --- Click Search button ---
    Wait Until Element Is Visible    ${SEARCH_BTN}    ${TIMEOUT}
    Click Element                    ${SEARCH_BTN}
    Sleep                            1s

    # --- Input name ---
    Wait Until Element Is Visible    ${SEARCH_BAR}    ${TIMEOUT}
    Click Element                    ${SEARCH_BAR}
    Input Text                       ${SEARCH_BAR}    Moses Armildez
    Sleep                            2s

    # --- Verify result ---
    ${user_found}=    Run Keyword And Return Status
    ...               Wait Until Element Is Visible    ${USER_CARD}    10s
    Run Keyword If    ${user_found}                    Log             User Moses Armildez found — PASS
    Run Keyword If    not ${user_found}                Fail            User Moses Armildez not found — FAIL

    Close Application
