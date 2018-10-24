module platemaker.NetworkDisplay;

import d2d;
import platemaker;

/**
 * A d2d activity that draws a plate network
 */
class NetworkDisplay : Activity {

    private PlateNetwork _network; ///The plate network to be displayed

    /**
     * Constructor for the display, takes in a container and a plate network
     */
    this(Display container, PlateNetwork network) {
        super(container);
        this._network = network;
    }

    /**
     * Getter and setter properties for network
     */
    @property void network(PlateNetwork network) {
        this._network = network;
    }
    @property PlateNetwork network() {
        return this._network;
    }

    /**
     * Draws the network to the screen
     * TODO:
     */
    override void draw() {
        this.container.renderer.clear(Color(150, 150, 150));
    }

    /**
     * Draws a PlateBound object
     */
    private void drawPlateBound(PlateBound bound) {
        Stack!dVector verts = bound.segments.softClone();
        while(!verts.isEmpty()) {
            dVector popped = verts.pop();
            this.container.renderer.draw(new iVector(cast(int) (popped.x * this.container.window.size.x / 2), 
                    cast(int) (popped.y * this.container.window.size.y)), 
                    new iVector(cast(int) (verts.peek().x * this.container.window.size.x / 2), 
                    cast(int) (verts.peek().y * this.container.window.size.y)));
        }
    }

}