module platemaker.PlateNetwork;

import std.algorithm;
import std.random;
import d2d;
import platemaker;

/**
 * An object which creates and stores tectonic plate networks
 */
class PlateNetwork {

    dVector[] junctions; ///A list of each junction between plate boundaries
    PlateBound[] boundaries; ///A list of every open plate boundary

    /**
     * Initalizes a new PlateNetwork
     * Begins with uniformly (with noise) distributed loci for triple junctions
     * Uses a "planet" that is twice as wide as it is tall (like a rectagular mapping of Earth)
     * numDivisions is equal to the number of starting boundary locations
     */
    this(int numDivisions) {
        //Create square areas with which to distribute the intial boundaries 
        //TODO: make loci better spacing with weight toward closer to the centers?
        double boundSize = 1.0 / numDivisions;
        for(double x = 0.0; x < 2.0; x += 2 * boundSize) {
            for(double y = 0.0; y < 1.0; y += boundSize) {
                //Runs thrice in order to have the boundary extend in three directions; inits a junction
                dVector location = new dVector(uniform(x, x + boundSize), uniform(y, y + boundSize));
                foreach(i; 0..3) this.boundaries ~= new PlateBound(location.x, location.y);
                this.junctions ~= location;
            }
        }
        //this.make();
    }

    /**
     * Generates a random plate network
     * Acts as the main method, of sorts
     * TODO:
     */
    void make() {
        //Currently a mode just as a test
        //Runs extend boundaries six times
        foreach(i; 0..100) {
            extendBoundaries();
        }
    }

    /**
     * Extends all actively growing plate boundaries
     * Runs the boundaries' append method, and checks if
     * the appended location causes an intersection
     * If so, closes the boundary
     * Checks for intersections after appending happens
     */
    void extendBoundaries() {
        for(int i = 0; i < this.boundaries.length; i++) {
            if(!this.boundaries[i].isClosed) {
                this.boundaries[i].append();
                if(this.boundaries[i].length > 2) {
                    this.intersects(this.boundaries[i]);
                }
            }
        }
    }

    /**
     * Checks for intersection
     * Intersection is defined as being closer to any point than
     * the maximum segment length from any point in the network
     * and not being on the same boundary
     * Uses the most recent point added of the given grown bound
     */
    bool intersects(PlateBound grownBound) {
        for(int i = 0; i < this.boundaries.length; i++) {
            if(grownBound !is this.boundaries[i]) {
                BoundJoint node = this.boundaries[i].initial;
                while(node !is null) {
                    if((grownBound.terminal.location - node.location).magnitude < BoundGenConstants.MAX_LENGTH) {
                        grownBound.add(new BoundJoint(node.location)); //Only takes the node's location, not its pointer
                        grownBound.isClosed = true;
                        this.boundaries ~= new PlateBound(node, this.boundaries[i].terminal, this.boundaries[i].isClosed, this.boundaries[i].prevAngle);
                        this.boundaries[i].terminal = new BoundJoint(node.location);
                        this.boundaries[i].isClosed = true;
                        return true;
                    }
                    node = node.next;
                }
            }
        }
        return false;
    }

}