##
## Example app using YaGUI

#import yagui
import ../src/yagui

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
    buttonAlert.y = 20
    buttonAlert.width = window.width - 60
    buttonAlert.height = 40
    buttonAlert.events.addListener("press"):
        if confirm("What's your answer?", "Question"):
            alert("You said YES!", "Alert!")
        else:
            alert("You said NO!", "Alert!")
    window.add(buttonAlert)
