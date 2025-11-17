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

# --- Settings Button ---
${SETTINGS_BTN}    xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.Button[2]

# --- ASL Alphabet Chart Button ---
${ALPHABET_BTN}    accessibility_id=ASL Alphabet (Chart)

# --- ASL Alphabet Chart Screen (for assertion) ---
${ALPHABET_SCREEN}    accessibility_id=ASL Alphabet Chart

*** Test Cases ***
Open ASL Alphabet Chart From Settings
    [Documentation]    Login → Home → Profile → Settings → Click ASL Alphabet Chart → Verify Chart Screen

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
    Wait Until Element Is Visible    xpath=${LOGIN_GOOGLE_XPATH}            ${TIMEOUT}
    Click Element                    xpath=${LOGIN_GOOGLE_XPATH}
    Wait Until Element Is Visible    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}    ${TIMEOUT}
    Click Element                    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}

    # --- Wait for Home screen ---
    Wait Until Element Is Visible    accessibility_id=${HOME_USER_ACCESSIBILITY_ID}    ${TIMEOUT}

    # --- Open Profile ---
    Wait Until Element Is Visible    ${PROFILE_BTN}    ${TIMEOUT}
    Click Element                    ${PROFILE_BTN}
    Sleep                            1s

    # --- Open Settings ---
    Wait Until Element Is Visible    ${SETTINGS_BTN}    ${TIMEOUT}
    Click Element                    ${SETTINGS_BTN}
    Sleep                            1s

    # --- Click ASL Alphabet Chart Button ---
    Wait Until Element Is Visible    ${ALPHABET_BTN}    ${TIMEOUT}
    Click Element                    ${ALPHABET_BTN}
    Sleep                            2s

    # --- Assertion: Verify Alphabet Chart Screen ---
    ${chart_present}=    Run Keyword And Return Status
    ...                  Wait Until Element Is Visible    ${ALPHABET_SCREEN}    10s
    Run Keyword If       ${chart_present}                 Log                   Alphabet Chart screen opened successfully (PASS)
    ...                  ELSE                             Fail                  Alphabet Chart screen not opened (FAIL)

    # --- Close App ---
    Close Application
