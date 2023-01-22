import classes
import ../global/baseimage
import winim/lean except COMPONENT, GROUP, BUTTON

##
## Represents an Image resource
class Image of BaseImage:

    ## Icon resource
    var pIconResource: HICON = 0

    ## Load from file
    method fromFile(filepath: string): Image {.static.} =

        # Create it
        let img = Image.init()
        return img