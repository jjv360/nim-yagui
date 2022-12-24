# 
# Simple dialogs on Windows

import winim except COMPONENT, GROUP, BUTTON

## Shows an alert dialog with a message
proc alert*(text: string, title: string = "Alert") =
    winim.MessageBox(0, text, title, winim.MB_OK or winim.MB_ICONINFORMATION)

## Shows a confirmation prompt dialog, returns true if the user pressed Ok
proc confirm*(text: string, title: string = "Question"): bool =
    let r = winim.MessageBox(0, text, title, winim.MB_OKCANCEL or winim.MB_ICONQUESTION)
    return r == winim.IDOK