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
global statusGui := {}

; Create the GUI
CreateGui()

; Hotkeys
^+e::ToggleScript()  ; Ctrl+Shift+E to toggle
^+r::Reload  ; Ctrl+Shift+R to reload
^+q::ExitApp  ; Ctrl+Shift+Q to exit

; Function to create the GUI
CreateGui() {
    global statusGui
    statusGui := Gui("+MinimizeBox")
    statusGui.Add("Text", "w300 h30 Center c000000", "Siralim Ultimate AutoBattle")  ; Static text at the top
    statusGui.Add("Text", "vStatusText w300 h30 Center")                             ; Status text below static text
    
    ; Place buttons horizontally using x and y positioning
    statusGui.Add("Button", "x10 y80 w140 h30", "Toggle Script").OnEvent("Click", ToggleScript)  ; First button at x10, y80
    statusGui.Add("Button", "x160 y80 w140 h30", "Quit").OnEvent("Click", QuitScript)           ; Second button at x160, y80
    
    statusGui.OnEvent("Close", (*) => ExitApp())
    statusGui.Title := "AutoBattle"
    statusGui.Show("NoActivate x10 y10 w320 h150")  ; Adjusted window size for layout
    UpdateStatusGui("Inactive")
    
    ; Make the GUI moveable
    statusGui.OnEvent("Size", (*) => {})
    OnMessage(0xA1, (*) => SendMessage(0xA1, 2))
}

; Function to update the status GUI
UpdateStatusGui(status) {
    if (statusGui) {
        statusGui["StatusText"].Value := status
        statusGui["StatusText"].Opt(status == "Active" ? "cGreen" : "cRed")
    }
}

; Toggle script function
ToggleScript(*) {
    global isRunning
    isRunning := !isRunning
    
    if (isRunning) {
        SetTimer SendKeyToWindow, 100
        UpdateStatusGui("Active")
        ShowToolTip("Script activated")
    } else {
        SetTimer SendKeyToWindow, 0
        UpdateStatusGui("Inactive")
        ShowToolTip("Script deactivated")
    }
}

; Quit script function
QuitScript(*) {
    ExitApp()
}

; Sends the 'E' key to the target window
SendKeyToWindow() {
    if WinExist(TARGET_WINDOW) {
        try {
            SendVirtualKey(VK_E)
        } catch as err {
            UpdateStatusGui("Error: " . err.Message)
            ShowToolTip("Error sending key: " . err.Message)
        }
    } else {
        UpdateStatusGui("Window not found")
        ShowToolTip("Siralim Ultimate window not found")
    }
}

; Sends a virtual key using PostMessage
SendVirtualKey(vkCode) {
    PostMessage WM_KEYDOWN, vkCode, 0, , TARGET_WINDOW
    PostMessage WM_KEYUP, vkCode, 0, , TARGET_WINDOW
}

; Displays a tooltip message briefly
ShowToolTip(message) {
    ToolTip(message)
    SetTimer () => ToolTip(), -500  ; Hide tooltip after .5 seconds
}
