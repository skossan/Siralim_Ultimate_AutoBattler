#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

; Constants
WM_KEYDOWN := 0x100
WM_KEYUP := 0x101
VK_E := 69  ; Virtual Key Code for 'E'
TARGET_WINDOW := "ahk_exe SiralimUltimate.exe"

; Globals
global isRunning := false

; Hotkeys
^+e::ToggleKeySending()  ; Ctrl+Shift+E to toggle
^+r::Reload              ; Ctrl+Shift+R to reload
^+q::ExitApp             ; Ctrl+Shift+Q to exit

; Toggles the script on/off
ToggleKeySending() {
    global isRunning
    static timerInterval := 100  ; Timer interval in ms
    
    isRunning := !isRunning
    
    if (isRunning) {
        SetTimer SendKeyToWindow, timerInterval
        ShowToolTip("Script activated")
    } else {
        SetTimer SendKeyToWindow, 0
        ShowToolTip("Script deactivated")
    }
}

; Sends the 'E' key to the target window
SendKeyToWindow() {
    if WinExist(TARGET_WINDOW) {
        try {
            SendVirtualKey(VK_E)
        } catch as err {
            ShowToolTip("Error sending key: " . err.Message)
        }
    } else {
        ShowToolTip("Siralim Ultimate window not found")
    }
}

; Sends a virtual key using PostMessage
SendVirtualKey(vkCode) {
    PostMessage WM_KEYDOWN, vkCode, 0, , TARGET_WINDOW  ; Key down
    PostMessage WM_KEYUP, vkCode, 0, , TARGET_WINDOW    ; Key up
}

; Displays a tooltip message briefly
ShowToolTip(message) {
    ToolTip(message)
    SetTimer () => ToolTip(), -500  ; Hide tooltip after .5 seconds
}
