import classes
import ./utils
import winim except COMPONENT, GROUP, BUTTON

##
## Represents a clickable button
class Button of WindowHwndHandler:

    ## Button title
    var title = "Button"

    ## Create the button
    method createHwnd(): HWND =

        # Stop if no parent window
        let parentHwnd = this.parentHWND()
        if parentHwnd == 0:
            return 0

        # Create it
        echo "here2"
        this.hwnd = CreateWindowEx(
            0,                              # Extra window styles
            L"BUTTON",                      # Class name ... system defined class
            L(this.title),                  # Button title
            WS_TABSTOP or WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON,   # Window style

            # Size and position, x, y, width, height
            10, 10, 100, 100,

            parentHwnd,                     # Parent window    
            0,                              # Menu
            0,                              # Instance handle
            cast[pointer](this)             # Additional application data is a pointer to our class instance ... used by wndProcProxy
        )