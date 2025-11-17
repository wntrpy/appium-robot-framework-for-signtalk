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

# --- Profile Button ---
${PROFILE_BTN}    xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View[3]

# --- Settings Button ---
${SETTINGS_BTN}    xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.Button[2]

# --- Feedback Button ---
${FEEDBACK_BTN}    accessibility_id=Feedback

# --- Feedback Input ---
${FEEDBACK_INPUT}    xpath=//android.widget.EditText

# --- Submit Button ---
${SUBMIT_BTN}    accessibility_id=Submit

*** Test Cases ***
Send Feedback Without Input
    [Documentation]    Login → Home → Profile → Settings → Feedback → Submit empty → Expect error message

    # --- Open App ---
    Open Application    http://localhost:4723
    ...                 platformName=${PLATFORM}
    ...                 deviceName=${DEVICE}
    ...                 automationName=UiAutomator2
    ...                 appPackage=${APP_PACKAGE}
    ...                 appActivity=${APP_ACTIVITY}
    ...                 newCommandTimeout=300

    Set Appium Timeout    60s

    # --- Handle notification modal again (sometimes appears after Google login) ---
    ${modal_after_login}=    Run Keyword And Return Status
    ...                      Wait Until Element Is Visible    id=${NOTIF_DIALOG_ID}    8s
    Run Keyword If           ${modal_after_login}             Click Element            id=${NOTIF_ALLOW_BUTTON_ID}
    Run Keyword If           ${modal_after_login}             Log                      Permission allowed after Google login

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

    # --- Click Feedback ---
    Wait Until Element Is Visible    ${FEEDBACK_BTN}    ${TIMEOUT}
    Click Element                    ${FEEDBACK_BTN}
    Sleep                            1s

    # --- Wait for Feedback Input ---
    Wait Until Element Is Visible    ${FEEDBACK_INPUT}    ${TIMEOUT}
    Click Element                    ${FEEDBACK_INPUT}    # focus input
    Sleep                            1s

    # --- DO NOT ENTER TEXT ---
    # intentionally skip Input Text

    # --- Submit ---
    Wait Until Element Is Visible    ${SUBMIT_BTN}    ${TIMEOUT}
    Click Element                    ${SUBMIT_BTN}
    Sleep                            1s

    # --- Verify Error Message ---
    ${hint}=          Get Element Attribute                        ${FEEDBACK_INPUT}            hint
    Should Contain    ${hint}                                      Feedback cannot be empty!    
    Log               Error message appeared as expected (PASS)

    # --- Close App ---
    Close Application
