import classes
import ./colorutils
import ./eventutils
import strutils

##
## Generic Component which can be added to the view heirarchy
class Component:

    ## Parent component
    var parent : Component = nil

    ## Child components
    var children : seq[Component]

    ## Position and size
    var x = 0.0
    var y = 0.0
    var width = 0.0
    var height = 0.0

    ## Background color
    var backgroundColor: ColorAlpha = colTransparent

    ## Event emitter
    var events: EventEmitter = EventEmitter.init()

    ## True if visible. Don't set this directly, use show(), hide() or setVisible() instead.
    var visible = true

    ## Remove from parent
    method removeFromParent() =

        # Remove if it has a parent
        if this.parent != nil:
            this.parent.remove(this)


    ## Add child component
    method add(child: Component) =

        # Check if it already has a parent
        if child.parent == this:
            return
        elif child.parent != nil:
            child.removeFromParent()

        # Add it
        this.children.add(child)
        child.parent = this
        
        # Perform system update from this component down
        this.performSystemUpdate()


    ## Remove a child
    method remove(child: Component) =

        # Stop if not our child
        if child.parent != this:
            return

        # Find index
        let idx = this.children.find(child)
        if idx == -1:
            return

        # Remove it
        this.children.del(idx)
        child.parent = nil
        
        # Perform system update from this component down
        this.performSystemUpdate()

        # Perform on the isolated child as well, so it can clean up resources etc
        child.performSystemUpdate()


    ## Configure underlying system UI and recalculate layouts etc
    method performSystemUpdate() =

        # Call our handler
        this.onSystemUpdate()
        
        # Call on all children as well
        for child in this.children:
            child.performSystemUpdate()


    ## Overridable handler to perform a system layout update for this component
    method onSystemUpdate() = discard


    ## Make the component visible
    method show() = this.setVisible(true)

    ## Hide this component
    method hide() = this.setVisible(false)

    ## Update component visibility
    method setVisible(visible: bool = true) =

        # Update it
        this.visible = visible

        # Perform system update
        this.performSystemUpdate()
        

    ## Debug utility: Print out the component heirarchy from this point
    method printViewHeirarchy(depth: int = 0) =

        # Print ours
        echo "  ".repeat(depth) & "- " & $this

        # Print children
        for child in this.children:
            child.printViewHeirarchy(depth + 1)


    ## String description of this component
    method `$`(): string =
        return this.className() & ": pos=" & $this.x.int() & "," & $this.y.int() & " size=" & $this.width.int() & "," & $this.height.int()