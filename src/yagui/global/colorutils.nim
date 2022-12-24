import colors
import parseutils
import strutils

## Color with alpha support, ie 0xAARRGGBB
type ColorAlpha* = distinct int64

## Convert a Nim color to one with alpha (just adds full opacity)
converter toColorAlpha*(input: Color): ColorAlpha =
    return (ColorAlpha) uint(input) or uint(0xFF000000)

## Convert integers to a color
converter toColorAlpha*(input: int): ColorAlpha = (ColorAlpha) input
converter toColorAlpha*(input: int64): ColorAlpha = (ColorAlpha) input
converter toColorAlpha*(input: uint32): ColorAlpha = (ColorAlpha) input
converter toColorAlpha*(input: uint64): ColorAlpha = (ColorAlpha) input

## Convert a CSS color string to 0xAARRGGBB
converter toColorAlpha*(a: string): ColorAlpha =

    # Convert #RGB to #AARRGGBB
    var input = a
    if input.startsWith("#") and input.len() == 4:
        input = "#FF" & input[1] & input[1] & input[2] & input[2] & input[3] & input[3]

    # Convert #ARGB to #AARRGGBB
    if input.startsWith("#") and input.len() == 5:
        input = "#" & input[1] & input[1] & input[2] & input[2] & input[3] & input[3] & input[4] & input[4]

    # Convert #RRGGBB to #AARRGGBB
    if input.startsWith("#") and input.len() == 7:
        input = "#FF" & input.substr(1)

    # Check if string is in #AARRGGBB format
    if input.startsWith("#") and input.len() == 9:
        var output = 0
        let numParsedChars = input.parseHex(output, 1)
        if numParsedChars != 8: raise newException(ValueError, "Input is not a valid CSS color string")
        return (ColorAlpha) output

    # TODO: Support the other formats such as rgba(1, 2, 3) etc
    raise newException(ValueError, "Input is not a valid CSS color string")




## Extra defined colors
const colTransparent* : ColorAlpha = 0x00000000
const colClear* : ColorAlpha = 0x00000000
const colDefault* : ColorAlpha = -1