# YaGUI for Nim

![](https://img.shields.io/badge/status-alpha-red)

Yet Another GUI lib for Nim. This library aims to:
- Be as lightweight as possible
- Be fully platform independent, while supporting as many platform-dependent features as possible
- Not require any custom build flags or thread support (where possible)
- Not reimplement anything that is already in the Nim std library

To run the example app, clone the repo and run `nimble test`

## Feature support

Feature                     | Win32 | MacOS | Ubuntu    | JS
----------------------------|-------|-------|-----------|--------
**General**                 |
Alert and confirm dialog    | ✔️   |       |           |
Timers                      | ✔️   |       |           |
**Components**              |
Button                      | 🚧   |       |           |
Context menu                | ✔️   |       |           |
System tray icon            | ✔️   |       |           |
Window                      | 🚧   |       |           |