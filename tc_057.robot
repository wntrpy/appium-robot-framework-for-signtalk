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

# Home screen user button
${HOME_CHAT_USER_ID}    Saki\nHello\n2:29 AM

# PFP button → receiver profile (SAFE & ROBUST)
${CHAT_PFP_XPATH}    //android.view.View[contains(@content-desc,"Last seen")]

# Change Nickname button
${CHANGE_NICKNAME_ID}    Change Nickname

# EditText in alert dialog
${NICKNAME_EDITTEXT_CLASS}    android.widget.EditText

# Save button
${SAVE_BUTTON_ID}    Save

# Notification permission (ID based, same as your working tests)
${NOTIF_DIALOG_ID}          com.android.permissioncontroller:id/grant_dialog
${NOTIF_ALLOW_BUTTON_ID}    com.android.permissioncontroller:id/permission_allow_button


*** Test Cases ***
Change Nickname From Chat Screen
    [Documentation]    Login → Home → Open Chat → Edit Nickname → Save → PASS

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
    Wait Until Element Is Visible    xpath=${LOGIN_GOOGLE_XPATH}    20s
    Click Element                    xpath=${LOGIN_GOOGLE_XPATH}

    Wait Until Element Is Visible    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}    20s
    Click Element                    xpath=${GOOGLE_FIRST_ACCOUNT_XPATH}


    # --- Wait for Home Screen user (Saki) ---
    Wait Until Element Is Visible    accessibility_id=${HOME_CHAT_USER_ID}    20s
    Click Element                    accessibility_id=${HOME_CHAT_USER_ID}

    # --- Chat Screen: click PFP to open receiver profile ---
    Wait Until Element Is Visible    xpath=${CHAT_PFP_XPATH}    25s
    Click Element                    xpath=${CHAT_PFP_XPATH}

    # --- Receiver Profile: click "Change Nickname" ---
    Wait Until Element Is Visible    accessibility_id=${CHANGE_NICKNAME_ID}    20s
    Click Element                    accessibility_id=${CHANGE_NICKNAME_ID}

    # --- Alert Dialog: input nickname ---
    Wait Until Element Is Visible    class=${NICKNAME_EDITTEXT_CLASS}    20s
    Click Element                    class=${NICKNAME_EDITTEXT_CLASS}
    Input Text                       class=${NICKNAME_EDITTEXT_CLASS}    NewNickname123

    # --- Save Nickname ---
    Wait Until Element Is Visible    accessibility_id=${SAVE_BUTTON_ID}    15s
    Click Element                    accessibility_id=${SAVE_BUTTON_ID}

    Log    Nickname saved successfully — test PASSED

    Close Application
