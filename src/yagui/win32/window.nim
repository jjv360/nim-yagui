import classes
import winim except COMPONENT, GROUP, BUTTON
import ./utils
import ../global/eventutils

##
## Creates a window on the screen
class Window of WindowHwndHandler:

    ## Window title
    var title = "YaGUI"

    ## True if the window should be borderless
    var borderless = false

    ## True if visible. Don't set this directly, use show(), hide() or setVisible() instead. Windows are hidden by default.
    var visible = false

    ## Create HWND
    method createHwnd(): HWND =

        # Create window flags
        var flags = WS_OVERLAPPEDWINDOW or WS_VISIBLE
        if this.borderless: flags = WS_POPUP or WS_VISIBLE

        # Create window
        return CreateWindowEx(
            0,                              # Extra window styles
            registerWindowClass(),          # Class name
            this.title,                     # Window title
            (DWORD) flags,                  # Window style

            # Size and position, x, y, width, height
            (int32) this.x, (int32) this.y, 
            (int32) this.width, (int32) this.height,

            0,                              # Parent window    
            0,                              # Menu
            0,                              # Instance handle
            cast[pointer](this)             # Additional application data is a pointer to our class instance ... used by wndProcProxy
        )


    ## WndProc callback
    method wndProc(hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT =

        # Check event
        if uMsg == WM_PAINT:

            # Get background color as an HBRUSH
            var brushColor = COLOR_WINDOW+1
            if int64(this.backgroundColor) >= 0: brushColor = int(this.backgroundColor) and 0x00FFFFFF
            let brush = CreateSolidBrush((COLORREF) brushColor)
            
            # Paint the background color onto the window
            var ps: PAINTSTRUCT
            var hdc = BeginPaint(hwnd, ps)
            FillRect(hdc, ps.rcPaint, brush)
            EndPaint(hwnd, ps)

            # Done
            return 0

        elif uMsg == WM_CLOSE:

            # The user pressed the Close button on the window
            let event = this.events.emit("close")

            # If not prevented, the default action is to destroy the window
            if not event.isDefaultPrevented:
                this.destroyHwnd()

            # Done
            return 0

        else:

            # Do default action
            return super.wndProc(hwnd, uMsg, wParam, lParam)