##
## Example app using YaGUI

#import yagui
import ../src/yagui
import asyncdispatch

## Entry point
startApp:

    # Create tray icon
    let tray = TrayIcon.init()
    tray.tooltip = "YaGUI example app"
    # tray.icon = "tray.png"
    tray.contextMenu = ContextMenu.init()
    tray.contextMenu.addItem("Hello from YaGUI", disabled = false): alert("Hello world!", "Alert!")
    tray.contextMenu.addItem("---")
    tray.contextMenu.addItem("Quit", disabled = false): yagui.exitApp()
    tray.show()

    # Create window
    let window = Window.init()
    window.title = "YaGUI showcase"
    window.x = 200
    window.y = 200
    window.width = 450
    window.height = 600
    # window.backgroundColor = "#333"
    window.events.addListener("close"): yagui.exitApp()
    window.show()

    # Add buttons for the different examples
    let buttonAlert = Button.init()
    buttonAlert.title = "Alert dialogs"
    buttonAlert.x = 20
    buttonAlert.y = 20 + 60 * 0
    buttonAlert.width = window.width - 60
    buttonAlert.height = 40
    window.add(buttonAlert)
    buttonAlert.events.addListener("press"):

        # Show a confirm dialog followed by an alert dialog
        if confirm("What's your answer?", "Question"):
            alert("You said YES!", "Alert!")
        else:
            alert("You said NO!", "Alert!")

    # Dynamic changing content
    let buttonChanging = Button.init()
    buttonChanging.title = "Timer: 0"
    buttonChanging.x = 20
    buttonChanging.y = 20 + 60 * 1
    buttonChanging.width = window.width - 60
    buttonChanging.height = 40
    window.add(buttonChanging)

    var counter = 0
    proc incrementCounterLoop() {.async.} =
        while true:
            counter += 1
            buttonChanging.title = "Timer: " & $counter
            # buttonChanging.update()
            await sleepAsync(1000)

    discard incrementCounterLoop()


    # Add buttons to create a window
    let buttonWindow = Button.init()
    buttonWindow.title = "Create a normal window"
    buttonWindow.x = 20
    buttonWindow.y = 20 + 60 * 2
    buttonWindow.width = window.width - 60
    buttonWindow.height = 40
    window.add(buttonWindow)
    buttonWindow.events.addListener("press"):

        # Create a new window
        let window2 = Window.init()
        window2.title = "A normal window"
        window2.x = 500
        window2.y = 500
        window2.width = 450
        window2.height = 450
        window2.show()


    # Add buttons to create a splash screen
    let buttonSplash = Button.init()
    buttonSplash.title = "Create a splash screen"
    buttonSplash.x = 20
    buttonSplash.y = 20 + 60 * 3
    buttonSplash.width = window.width - 60
    buttonSplash.height = 40
    window.add(buttonSplash)
    buttonSplash.events.addListener("press"):

        # Create a new window
        let window3 = Window.init()
        window3.title = "Splash"
        window3.x = 500
        window3.y = 500
        window3.width = 512
        window3.height = 512
        window3.borderless = true
        window3.backgroundColor = colTransparent
        window3.show()


    echo "YaGUI example app running!"