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

# --- Notification permission (use XPATHs like your other tests) ---
${NOTIF_DIALOG_XPATH}          //android.widget.LinearLayout[@resource-id="com.android.permissioncontroller:id/grant_dialog"]
${NOTIF_ALLOW_BUTTON_XPATH}    //android.widget.Button[@resource-id="com.android.permissioncontroller:id/permission_allow_button"]

# --- Home screen ---
${HOME_USER_ACCESSIBILITY_ID}    moses\nHello 🙂👍 #sign\n2:31 AM

# --- Profile Button ---
${PROFILE_BTN}    xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View[3]

# --- Settings Button ---
${SETTINGS_BTN}    xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.Button[2]

# --- Logout Button ---
${LOGOUT_BTN}    accessibility_id=Log out

# --- Login Icon (for assertion after logout) ---
${LOGIN_ICON}    xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.ImageView[1]

*** Test Cases ***
Logout From Settings
    [Documentation]    Login → Home → Profile → Settings → Logout → Verify Login Screen → Back Button Check

    # --- Open App ---
    Open Application    http://localhost:4723
    ...                 platformName=${PLATFORM}
    ...                 deviceName=${DEVICE}
    ...                 automationName=UiAutomator2
    ...                 appPackage=${APP_PACKAGE}
    ...                 appActivity=${APP_ACTIVITY}
    ...                 newCommandTimeout=300

    Set Appium Timeout    60s

    # --- Handle notification modal immediately (may appear on app launch) ---
    ${dialog_present_start}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${NOTIF_DIALOG_XPATH}                       6s
    Run Keyword If              ${dialog_present_start}          Click Element                    xpath=${NOTIF_ALLOW_BUTTON_XPATH}
    Run Keyword If              ${dialog_present_start}          Log                              Notification permission allowed (on app start)

    # --- Login with Google ---
    Wait Until Element Is Visible    xpath=${LOGIN_GOOGLE_XPATH}            ${TIMEOUT}
    Click Element                    xpath=${LOGIN_GOOGLE_XPATH}
    Wait Until Element Is Visible    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}    ${TIMEOUT}
    Click Element                    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}

    # --- Handle notification modal again (sometimes appears after Google account selection) ---
    ${dialog_present_after}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${NOTIF_DIALOG_XPATH}                             8s
    Run Keyword If              ${dialog_present_after}          Click Element                    xpath=${NOTIF_ALLOW_BUTTON_XPATH}
    Run Keyword If              ${dialog_present_after}          Log                              Notification permission allowed (after Google login)

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

    # --- Click Logout (with fallback tap) ---
    ${clicked}=       Run Keyword And Return Status    Click Element                                    ${LOGOUT_BTN}
    Run Keyword If    not ${clicked}
    ...               Log To Console                   Normal click failed, trying coordinate tap...
    ...               ${loc}=                          Get Element Location                             ${LOGOUT_BTN}
    ...               ${size}=                         Get Element Size                                 ${LOGOUT_BTN}
    ...               ${x}=                            Evaluate                                         ${loc['x']} + ${size['width']} / 2
    ...               ${y}=                            Evaluate                                         ${loc['y']} + ${size['height']} / 2
    ...               Click                            ${x}                                             ${y}

    Sleep    2s

    # --- Verify Login Screen ---
    ${login_present}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${LOGIN_ICON}                                            10s
    Run Keyword If       ${login_present}                 Log                              Logout successful — redirected to login screen (PASS)
    Run Keyword If       not ${login_present}             Fail                             Logout failed — did not reach login screen (FAIL)

    # --- Press Back Button to check app exit ---
    Press Keycode    4
    Sleep            2s

    # --- Check if app is still showing login screen ---
    ${still_present}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${LOGIN_ICON}                                                    5s
    Run Keyword If       ${still_present}                 Fail                             App did not exit — back button went to previous screen (FAIL)
    ...                  ELSE                             Log                              Back button exited app successfully (PASS)

    # --- Close App ---
    Close Application
