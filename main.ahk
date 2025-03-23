#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

global isRunning := false
global debugInfo := ""

^+e::ToggleScript()  ; Ctrl+Shift+E to toggle
^+r::Reload  ; Ctrl+Shift+R to reload
^+q::ExitApp  ; Ctrl+Shift+Q to exit

ToggleScript() {
    global isRunning, debugInfo
    isRunning := !isRunning
    
    if (isRunning) {
        SetTimer SendE, 100
        ShowToolTip("Script activated")
    } else {
        SetTimer SendE, 0
        ShowToolTip("Script deactivated")
    }
}

SendE() {
    if WinExist("ahk_exe SiralimUltimate.exe") {
        try {
            PostMessage 0x100, 69, 0, , "ahk_exe SiralimUltimate.exe"  ; WM_KEYDOWN for 'E'
            PostMessage 0x101, 69, 0, , "ahk_exe SiralimUltimate.exe"  ; WM_KEYUP for 'E'
        } catch as err {
            ShowToolTip("Error sending key: " . err.Message)
        }
    } else {
        ShowToolTip("Siralim Ultimate window not found")
    }
}

ShowToolTip(message) {
    ToolTip(message)
    SetTimer () => ToolTip(), -500  ; Hide tooltip after .5 seconds
}
