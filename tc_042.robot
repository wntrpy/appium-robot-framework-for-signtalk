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

# --- Search button on Home ---
${SEARCH_BTN}    accessibility_id=Search contact...

# --- Search bar in Search screen ---
${SEARCH_BAR}    class=android.widget.EditText

# --- User card for search result ---
${USER_CARD}    accessibility_id=Saki\nmosesarmildez52@gmail.com

# --- Message screen locators ---
${MESSAGE_EDITTEXT}    class=android.widget.EditText
${SEND_BTN}            xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.widget.Button[3]

# --- Back buttons ---
${CHAT_BACK_BTN}      accessibility_id=Back
${SEARCH_BACK_BTN}    class=android.widget.Button

# --- Home screen assertion after returning ---
${HOME_ASSERT}    xpath=//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.widget.ImageView[2]

# --- Notification permission ---
${NOTIF_DIALOG_ID}          com.android.permissioncontroller:id/grant_dialog
${NOTIF_ALLOW_BUTTON_ID}    com.android.permissioncontroller:id/permission_allow_button

*** Test Cases ***
Search User And Send Message
    [Documentation]    Login → Home → Search → Input Name → Click User → Chat → Send Message → Back → Search → Back → Home → Verify

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

    # --- Click Search button ---
    Wait Until Element Is Visible    ${SEARCH_BTN}    ${TIMEOUT}
    Click Element                    ${SEARCH_BTN}
    Sleep                            1s

    # --- Input name in Search bar ---
    Wait Until Element Is Visible    ${SEARCH_BAR}    ${TIMEOUT}
    Click Element                    ${SEARCH_BAR}
    Input Text                       ${SEARCH_BAR}    Saki
    Sleep                            2s

    # --- Click the user card ---
    Wait Until Element Is Visible    ${USER_CARD}    ${TIMEOUT}
    Click Element                    ${USER_CARD}
    Sleep                            1s

    # --- Input message ---
    Wait Until Element Is Visible    ${MESSAGE_EDITTEXT}    ${TIMEOUT}
    Click Element                    ${MESSAGE_EDITTEXT}
    Input Text                       ${MESSAGE_EDITTEXT}    Hello
    Sleep                            1s

    # --- Click Send button ---
    Wait Until Element Is Visible    ${SEND_BTN}    ${TIMEOUT}
    Click Element                    ${SEND_BTN}

    # --- Assertion: verify message sent (send button enabled again) ---
    ${send_enabled}=    Run Keyword And Return Status
    ...                 Element Should Be Enabled        ${SEND_BTN}
    Run Keyword If      ${send_enabled}                  Log            Message sent successfully — PASS
    ...                 ELSE                             Fail           Message not sent — FAIL

    # --- Click Back button from chat to return to Search screen ---
    Wait Until Element Is Visible    ${CHAT_BACK_BTN}    ${TIMEOUT}
    Click Element                    ${CHAT_BACK_BTN}
    Sleep                            1s

    # --- Click Back button from Search screen to return to Home screen ---
    Wait Until Element Is Visible    ${SEARCH_BACK_BTN}    ${TIMEOUT}
    Click Element                    ${SEARCH_BACK_BTN}
    Sleep                            1s

    # --- Assert Home screen is visible ---
    ${home_visible}=    Run Keyword And Return Status
    ...                 Wait Until Element Is Visible    ${HOME_ASSERT}    ${TIMEOUT}
    Run Keyword If      ${home_visible}                  Log               Returned to Home screen — PASS
    ...                 ELSE                             Fail              Did not return to Home screen — FAIL

    # --- Close App ---
    Close Application
