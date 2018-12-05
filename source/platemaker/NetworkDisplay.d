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
     * Searches only for intermediate joints, since all intermediate joints will
     * be connected to the remaining joints
     */
    override void draw() {
        this.container.renderer.drawColor = Color(150, 150, 150);
        this.container.renderer.clear();
        this.container.renderer.drawColor = Color(0, 0, 0);
        foreach(joint; this._network.allJoints) {
            if(cast(InterJoint) joint) {
                if((cast(InterJoint) joint).prevJoint !is null) {
                    this.container.renderer.draw(new iVector(this.container.window.size.x / 2 * cast(int) joint.location.x, 
                            this.container.window.size.y * cast(int) joint.location.y), 
                            new iVector(this.container.window.size.x / 2 * cast(int) (cast(InterJoint) joint).prevJoint.location.x, 
                            this.container.window.size.y * cast(int) (cast(InterJoint) joint).prevJoint.location.y));
                }
                if((cast(InterJoint) joint).nextJoint !is null) {
                    this.container.renderer.draw(new iVector(this.container.window.size.x / 2 * cast(int) joint.location.x, 
                            this.container.window.size.y * cast(int) joint.location.y), 
                            new iVector(this.container.window.size.x / 2 * cast(int) (cast(InterJoint) joint).nextJoint.location.x, 
                            this.container.window.size.y * cast(int) (cast(InterJoint) joint).nextJoint.location.y));
                }
            }
        }
    }

    /**
     * Handles events
     */
    override void handleEvent(SDL_Event event) {

    }

}