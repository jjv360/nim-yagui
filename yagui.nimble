# Package

version       = "0.1.0"
author        = "jjv360"
description   = "Yet Another GUI lib for Nim. Supports dialogs (alert, confirm), tray icons, etc."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.10"
requires "classes >= 0.2.13"
requires "winim >= 3.9.0"


# Build tasks

task test, "Run the example app":
    exec "nim compile --run example/app.nim"