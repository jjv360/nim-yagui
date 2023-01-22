import classes
import tables

## Callback types
type EventListenerCanceller* = proc()

##
## Represents a single event
class Event:

    ## Event name
    var eventName = ""

    ## True if someone called preventDefault()
    var isDefaultPrevented = false

    ## Prevent the default system action for this event
    method preventDefault() =
        this.isDefaultPrevented = true


##
## Event emitter class
class EventEmitter:

    ## Event map
    var eventsMap: Table[string, seq[proc(event: Event)]]

    ## Add listener. Returns a function which can be called to remove the listener.
    method addListener(eventName: string, callback: proc()): EventListenerCanceller {.discardable.} =

        # Create wrapper callback which discards the Event
        this.addListener(eventName, proc(event: Event) = callback())


    ## Add listener. Returns a function which can be called to remove the listener.
    method addListener(eventName: string, callback: proc(event: Event)): EventListenerCanceller {.discardable.} =

        # Add group if needed
        if not this.eventsMap.hasKey(eventName):
            this.eventsMap[eventName] = @[]

        # Add handler
        this.eventsMap[eventName].add(callback)

        # Create function to remove it
        return proc() =
            this.removeListener(eventName, callback)

    
    # Remove listener
    method removeListener(eventName: string, callback: proc(event: Event)) =

        # Stop if group doesn't exist
        echo "REMOVING"
        if not this.eventsMap.hasKey(eventName):
            return

        # Find item index
        let idx = this.eventsMap[eventName].find(callback)
        if idx == -1:
            return

        # Remove it
        this.eventsMap[eventName].del(idx)


    # Emit an event with no data
    method emit(eventName: string): Event {.discardable.} =

        # Create event object
        let event = Event.init()
        event.eventName = eventName

        # Emit it
        this.emit(event)

        # Return the created event
        return event


    # Emit an event object
    method emit(event: Event) =

        # Stop if group doesn't exist
        if not this.eventsMap.hasKey(event.eventName):
            return

        # Go through all callbacks
        for callback in this.eventsMap[event.eventName]:

            # Catch errors
            try:
                callback(event)
            except:
                echo "Uncaught exception handling event '" & event.eventName & ": " & $getCurrentExceptionMsg()