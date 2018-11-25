module platemaker.NetworkDisplay;

import d2d;
import platemaker;

immutable Color[] colors = [Color(255, 0, 0), Color(0, 255, 0), Color(0, 0, 255), Color(255, 255, 0), Color(255, 0, 255), Color(0, 255, 255),
                            Color(125, 0, 0), Color(0, 125, 0), Color(0, 0, 125), Color(255, 125, 0), Color(255, 0, 125), Color(0, 255, 125),
                            Color(125, 255, 0), Color(125, 0, 255), Color(0, 125, 125), Color(125, 125, 0), Color(125, 0, 125), Color(0, 125, 125)];

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
        this.container.renderer.clear(Color(50, 50, 50));
        for(int i = 0; i < this._network.boundaries.length; i++) {
            this.drawPlateBound(this._network.boundaries[i], i);
        }
    }

    /**
     * Draws a PlateBound object
     */
    private void drawPlateBound(PlateBound bound, int index) {
        /*if(bound.isClosed) this.container.renderer.drawColor = Color(255, 255, 255);
        else*/ this.container.renderer.drawColor = colors[index % colors.length];
        BoundJoint node = bound.initial;
        while(node !is null && node.next !is null) {
            this.container.renderer.draw(new iVector(cast(int) (node.location.x * this.container.window.size.x / 2), 
                    cast(int) (node.location.y * this.container.window.size.y)), 
                    new iVector(cast(int) (node.next.location.x * this.container.window.size.x / 2), 
                    cast(int) (node.next.location.y * this.container.window.size.y)));
            node = node.next;
        }
    }

    /**
     * Handles events
     */
    override void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN) {
            this._network.extendBoundaries();
        }
    }

}