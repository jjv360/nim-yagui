#
# Core functions for the main app

import winim except COMPONENT, GROUP, BUTTON
import ./timers
import asyncdispatch

## Allow other libraries access to the Win32 message queue
var win32MessageQueueHandlers*: seq[proc()]

## Starts the application UI thread
proc startApp*(appCode: proc()) =

    # Only do once
    var isRunning {.global.} = false
    if isRunning: return
    isRunning = true

    # Set DPI awareness
    SetProcessDPIAware()

    # Run application startup code
    appCode()

    # Create Win32 timer so our event loop is running at a minimum of 1ms, this is necessary to keep using the main thread for our timers
    SetTimer(0, 0, 1, nil)

    # Run the Windows event loop
    var msg: MSG
    while GetMessage(msg, 0, 0, 0) != 0:

        # Dispatch Windows message
        TranslateMessage(msg)
        DispatchMessage(msg)

        # Handle timers
        internalProcessTimers()

        # Process asyncdispatch's event loop
        if asyncdispatch.hasPendingOperations():
            asyncdispatch.poll(0)

        # Run extra functions
        for item in win32MessageQueueHandlers:
            item()


    # App is no longer running
    isRunning = false


## Exit the application
proc exitApp*(code : int = 0) =

    # Send terminate message
    PostQuitMessage((int32) code)

    # Quit the app
    quit(code)