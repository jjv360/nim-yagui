import classes
import winim/lean except COMPONENT, GROUP, BUTTON
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
        let hwnd = CreateWindowEx(
            WS_EX_LAYERED,                  # Extra window styles
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

        # Create graphics memory for the window
        # let screenDC = GetDC(0)
        # let windowDC = CreateCompatibleDC(screenDC)

        # # Create blend function info
        # var blend : BLENDFUNCTION
        # blend.BlendOp = AC_SRC_OVER
        # blend.SourceConstantAlpha = 255
        # blend.AlphaFormat = AC_SRC_ALPHA


        # var ptPos = POINT(x: this.x.int32, y: this.y.int32)
        # var sizeWnd = SIZE(cx: this.width.int32, cy: this.height.int32)

        # # Position of content in the DC
        # var ptSrc = POINT(x: 0, y: 0)

        # # # Update layered window
        # let success = UpdateLayeredWindow(hwnd, screenDC, &ptPos, &sizeWnd, windowDC, &ptSrc, 0, blend, ULW_ALPHA)
        # let success = SetLayeredWindowAttributes(hwnd, 0, 255, LWA_ALPHA)
        # if success == 0:
        #     echo "[YaGUI] Warning: Unable to call SetLayeredWindowAttributes. " & GetLastErrorString()

        # Show window
        # ShowWindow(hwnd, SW_SHOWNORMAL)

        # Draw background color
        this.p_updateLayeredWindow(hwnd)

        # Done
        return hwnd


    ## (private) Draw the background color for the window and set it's position and size
    method p_updateLayeredWindow(hwnd: HWND) =

        # Stop if it's using the default color
        # if this.backgroundColor == colDefault:
        #     return

        # Get window's HDC
        echo "UPDATE"
        # var hdc = GetDC(hwnd)
        # var screenHDC : HDC = 0
        # if hdc == 0 or true:

            # None created yet, create one now
        echo "CREATE hdc"
        let screenHDC = GetDC(0)
        let hdc = CreateCompatibleDC(screenHDC)

        # Get window bitmap buffer
        # var bmp = GetCurrentObject(hdc, OBJ_BITMAP)
        # if bmp == 0 or true:

            # Nonce created yet, create new bitmap
        echo "CREATE bmp"
        let bmp = CreateCompatibleBitmap(hdc, this.width.int32, this.height.int32)
        SelectObject(hdc, bmp)

        # Ensure the window size matches the bitmap size
        # var size : SIZE
        # GetBitmapDimensionEx(bmp, size)
        # if size.cx != this.width.int32 or size.cy != this.height.int32:

        #     # Window was resized! Destroy the old bitmap and create a new one of the right size
        #     echo "UPDATE bmp ... old size " & $size
        #     let oldBmp = bmp
        #     bmp = CreateCompatibleBitmap(hdc, this.width.int32, this.height.int32)
        #     SelectObject(hdc, bmp)
        #     # DeleteObject(oldBmp)

        # Draw color into the bitmap
        let brush = CreateSolidBrush((COLORREF) int(this.backgroundColor) and 0x00FFFFFF)
        SelectObject(hdc, brush)
        # Rectangle(hdc, 10, 10, 20, 20)
        var rect = RECT(left: 10, top: 10, right: 20, bottom: 20)
        FillRect(hdc, rect, brush)

        # Update the window# Create blend function info
        var windowPosition = POINT(x: this.x.int32, y: this.y.int32)
        var windowSize = SIZE(cx: this.width.int32, cy: this.height.int32)
        var bufferPosition = POINT(x: 0, y: 0)
        var blendFunc = BLENDFUNCTION(BlendOp: AC_SRC_OVER, BlendFlags: 0, SourceConstantAlpha: 255, AlphaFormat: AC_SRC_ALPHA)
        let success = UpdateLayeredWindow(hwnd, screenHDC, &windowPosition, &windowSize, hdc, &bufferPosition, 0, &blendFunc, ULW_ALPHA)
        if success == 0:
            echo "[YaGUI] Warning: Unable to call UpdateLayeredWindow. " & GetLastErrorString()

        # ShowWindow(hwnd, SW_SHOWNORMAL)
        # Cleanup
        DeleteDC(hdc)


    ## WndProc callback
    method wndProc(hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT =

        # Check event
        # if uMsg == WM_CREATE:

        #     # Update back buffer
        #     this.p_updateLayeredWindow(this.hwnd)
        #     return 0
        # if uMsg == WM_PAINT:

        #     # Get background color as an HBRUSH
        #     echo "WM_PAINT"
        #     var brush = COLOR_WINDOW+1
        #     if int64(this.backgroundColor) >= 0: 
        #         brush = CreateSolidBrush((COLORREF) int(this.backgroundColor) and 0x00FFFFFF)

        #     # Win32 doesn't support half transparency, so if transparency is 0 then use a clear brush
        #     var isTransparent = false
        #     if int64(this.backgroundColor) >= 0 and (this.backgroundColor.int() and 0xFF000000) == 0:
        #         isTransparent = true
            
        #     # Paint the background color onto the window
        #     # if not isTransparent: 
        #     var ps: PAINTSTRUCT
        #     var hdc = BeginPaint(hwnd, ps)
        #     FillRect(hdc, ps.rcPaint, brush)
        #     EndPaint(hwnd, ps)

        #     # Done
        #     return 0

        if uMsg == WM_SIZE:

            # Window was resized
            this.width = LOWORD(lParam).float()
            this.height = HIWORD(lParam).float()

            # Update platform
            this.performSystemUpdate()
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