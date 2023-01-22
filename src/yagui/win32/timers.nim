import winim/lean except COMPONENT, GROUP, BUTTON
import ./utils
import classes
import times

## Timer info
class InternalTimerInfo:
    var id = 0
    var runAt = 0.0
    var interval = 0.0
    var removeOnRun = false
    var callback: proc() = nil

# List of active timers
var lastTimerID = 1
var timers: seq[InternalTimerInfo]

## Create a once-off timer
proc scheduleOnce*(delaySeconds: float, callback: proc()): int =

    # Generate ID
    let id = lastTimerID
    lastTimerID += 1

    # Create timer
    let timer = InternalTimerInfo.init()
    timer.id = id
    timer.runAt = epochTime() + delaySeconds
    timer.removeOnRun = true
    timer.callback = callback
    timers.add(timer)
    return id


## Create a continuous timer
proc scheduleInterval*(delaySeconds: float, intervalSeconds: float, callback: proc()): int =

    # Generate ID
    let id = lastTimerID
    lastTimerID += 1

    # Create timer
    let timer = InternalTimerInfo.init()
    timer.id = id
    timer.runAt = epochTime() + delaySeconds
    timer.interval = intervalSeconds
    timer.callback = callback
    timers.add(timer)
    return id


## Remove a timer
proc removeTimer*(id: int) =

    # Go through them all
    var i = 0
    while i < timers.len():

        # Check if matched
        let info = timers[i]
        if info.id != id:
            i += 1
            continue

        # Remove this one
        timers.del(i)
        break



## Process timers
proc internalProcessTimers*() =

    # Get current time
    let now = epochTime()

    # Go through all active timers
    var i = 0
    while i < timers.len():

        # Check if timer should run
        let info = timers[i]
        if now < info.runAt:
            i += 1
            continue

        # Run it
        try:
            info.callback()
        except:
            echo "Uncaught exception in timer: " & $getCurrentExceptionMsg()

        # Remove if requested
        if info.removeOnRun:
            timers.del(i)
            i -= 1

        # Update the timer's next run date
        info.runAt = now + info.interval

        # Done
        i += 1