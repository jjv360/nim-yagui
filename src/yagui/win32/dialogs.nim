# 
# Simple dialogs on Windows

import winim/lean except COMPONENT, GROUP, BUTTON

## Shows an alert dialog with a message
proc alert*(text: string, title: string = "Alert") =
    MessageBox(0, text, title, MB_OK or MB_ICONINFORMATION)

## Shows a confirmation prompt dialog, returns true if the user pressed Ok
proc confirm*(text: string, title: string = "Question"): bool =
    let r = MessageBox(0, text, title, MB_OKCANCEL or MB_ICONQUESTION)
    return r == IDOK