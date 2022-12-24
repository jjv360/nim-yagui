import classes
import winim except COMPONENT, GROUP, BUTTON
import ./utils
import ./contextmenu

## Custom uMsg for notification icon stuff
const NOTIFICATION_TRAY_ICON_MSG = WM_USER + 0x100

##
## Creates a system tray icon
class TrayIcon of WindowHwndHandler:

    ## Icon
    var icon = "" #: Image = nil

    ## Tooltip
    var tooltip = ""

    ## GUID of the icon
    var pGuid : GUID

    ## Context menu to display on right click
    var contextMenu : ContextMenu = nil

    ## Action on left click
    var clickCallback : proc() = nil

    ## True if visible. Don't set this directly, use show(), hide() or setVisible() instead. Tray icons are hidden by default.
    var visible = false

    ## Constructor
    method init() =

        # Create GUID
        CoCreateGuid(this.pGuid)


    ## Create the tray icon
    method createHwnd(): HWND =

        # Create hidden message window
        let hwnd = super.createHwnd()

        # Create notify icon
        this.updateShellNotifyIcon(hwnd, NIM_ADD)

        # Done
        return hwnd


    ## Update the tray icon
    method updateHwnd() =
        super.updateHwnd()

        # Update notify icon
        this.updateShellNotifyIcon(this.hwnd, NIM_MODIFY)


    ## Destroy the HWND
    method detroyHwnd() =

        # Remove shell icon
        this.updateShellNotifyIcon(this.hwnd, NIM_DELETE)

        # Destroy window
        super.destroyHwnd()



    ## Private: Update the shell icon
    method updateShellNotifyIcon(messageWindow: HWND, action: int) =

        # Get icon resource
        var hIcon : HICON = 0
        if this.icon == "":

            # Load default application icon from the system
            hIcon = LoadIconW(0, IDI_APPLICATION)

        else:

            # Load resource from file
            let bytes = readFile(this.icon)
            hIcon = CreateIconFromResource(cast[PBYTE](&bytes), (DWORD) bytes.len(), true, 0x30000)

        # Create icon information
        var info : NOTIFYICONDATAW
        info.cbSize = (DWORD) sizeof(NOTIFYICONDATAW)
        info.hWnd = messageWindow
        info.uFlags = NIF_TIP or NIF_GUID or NIF_ICON or NIF_MESSAGE
        info.hIcon = hIcon
        info.szTip <<< L(this.tooltip.substr(0, 126))
        info.guidItem = this.pGuid
        info.uVersion = NOTIFYICON_VERSION_4
        info.uCallbackMessage = NOTIFICATION_TRAY_ICON_MSG

        # Create or update icon
        if Shell_NotifyIconW((DWORD) action, info) == 0:
            echo("[YaGUI] Unable to update tray icon. " & GetLastErrorString())
            return


    ## WndProc callback
    method wndProc(hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT =

        # Check event
        if uMsg == NOTIFICATION_TRAY_ICON_MSG and LOWORD(lParam) == WM_LBUTTONUP:
            
            # Left click, prioritise the click handler
            if this.clickCallback != nil:
                this.clickCallback()
            elif this.contextMenu != nil:
                this.contextMenu.show()

            # Done
            return 0

        elif uMsg == NOTIFICATION_TRAY_ICON_MSG and LOWORD(lParam) == WM_RBUTTONUP:
            
            # Right click, prioritise the context menu
            if this.contextMenu != nil:
                this.contextMenu.show()
            elif this.clickCallback != nil:
                this.clickCallback()

            # Done
            return 0

        else:

            # Do default action
            return super.wndProc(hwnd, uMsg, wParam, lParam)
