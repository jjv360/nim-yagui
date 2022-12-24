# 
# This library provides GUI components for Nim apps to use.

# Platform-independent classes
import yagui/global/basecomponent
import yagui/global/colorutils
import yagui/global/eventutils
export basecomponent, colorutils, eventutils

# Win32 classes
when defined(win32):
    import yagui/win32/app
    import yagui/win32/dialogs
    import yagui/win32/tray
    import yagui/win32/contextmenu
    # import yagui/win32/image
    import yagui/win32/window
    import yagui/win32/timers
    import yagui/win32/buttons
    export app, dialogs, tray, contextmenu, window, timers, buttons
