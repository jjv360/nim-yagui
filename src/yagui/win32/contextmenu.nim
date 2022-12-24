import winim except COMPONENT, GROUP, BUTTON
import classes
import sequtils
import ./utils

## Last used menu item ID
var lastMenuID = 1

##
## Represents a menu item
class ContextMenuItem:

    ## Item name
    var name = ""

    ## Callback
    var callback : proc()

    ## True if the menu item is not selectable
    var disabled = false

    ## Menu item ID
    var menuItemID = 0

    ## Constructor
    method init() =

        # Generate a unique menu item ID
        lastMenuID += 1
        this.menuItemID = lastMenuID


##
## Create a context menu which can be shown at any coordinate on the screen
class ContextMenu of WindowHwndHandler:

    ## List of menu items
    var items : seq[ContextMenuItem]

    ## Menu
    var hMenu : HMENU = 0

    ## Helper to add a menu item
    method addItem(name: string, disabled: bool = false, callback: proc() = nil) =
        
        # Add it
        let item = ContextMenuItem.init()
        item.name = name
        item.callback = callback
        item.disabled = disabled
        this.items.add(item)


    ## Show it
    method show() =

        # Create the underlying window if necessary
        super.show()

        # Hide if already shown
        if this.hMenu != 0:
            this.hide()

        # Create menu
        this.hMenu = CreatePopupMenu()
        
        # Add menu items
        for item in this.items:

            # Get flags
            var flags = MF_STRING
            if item.disabled: flags = flags or MF_GRAYED
            if item.name == "---": flags = MF_SEPARATOR

            # Append it
            AppendMenu(this.hMenu, (UINT) flags, item.menuItemID, item.name)

        # Get cursor position
        var pos : POINT
        GetCursorPos(pos)

        # Show the menu
        TrackPopupMenu(this.hMenu, 0, pos.x, pos.y, 0, this.hwnd, nil)


    ## Hide it
    method hide() =

        # Destroy window
        if this.hMenu != 0: DestroyMenu(this.hMenu)
        this.hMenu = 0

    
    ## WndProc callback
    method wndProc(hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT =

        # Check event
        if uMsg == WM_COMMAND:

            # Close menu
            this.hide()
            
            # Get menu item with the specified ID
            let menuID = (int) LOWORD(wParam)
            let menuItem = this.items.filterIt(it.menuItemID == menuID)
            if menuItem.len() == 0:
                return

            # Handle it
            if menuItem[0].callback != nil:
                menuItem[0].callback()

        else:

            # Do default action
            return super.wndProc(hwnd, uMsg, wParam, lParam)

