import classes
import ./utils
import winim/lean except COMPONENT, GROUP, BUTTON
import ../global/eventutils

##
## Represents a clickable button
class Button of WindowHwndHandler:

    ## Button title
    # var title = "Button"
    var p_title = "Button"
    method title(): string = this.p_title
    method `title=`(v: string) =
        this.p_title = v
        this.performSystemUpdate()

    ## Create the button
    method createHwnd(): HWND =

        # Stop if no parent window
        let parentHwnd = this.parentHWND()
        if parentHwnd == 0:
            return 0

        # Create it
        return CreateWindowEx(
            0,                              # Extra window styles
            L"BUTTON",                      # Class name ... system defined class
            L(this.title),                  # Button title
            WS_TABSTOP or WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON,   # Window style

            # Size and position, x, y, width, height
            (int32) this.x, (int32) this.y, 
            (int32) this.width, (int32) this.height,

            parentHwnd,                     # Parent window    
            0,                              # Menu
            0,                              # Instance handle
            cast[pointer](this)             # Additional application data is a pointer to our class instance ... used by wndProcProxy
        )


    ## Update the button
    method updateHwnd() =
        super.updateHwnd()

        # Update title
        SetWindowText(this.hwnd, L(this.title))


    ## WndProc callback for controls
    method controlWndProc(hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT =

        # Check message
        let code = HIWORD(wParam)
        if code == BN_CLICKED:

            # Emit event
            this.events.emit("press")
            return 0

        else:

            # Unknown message
            return super.controlWndProc(hwnd, uMsg, wParam, lParam)