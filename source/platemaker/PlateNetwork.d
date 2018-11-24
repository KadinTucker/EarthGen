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
     */
    void extendBoundaries() {
        for(int i = 0; i < this.boundaries.length; i++) {
            if(!this.boundaries[i].isClosed) {
                dVector newPoint = this.boundaries[i].append();
                if(this.boundaries[i].length > 3) {
                    this.intersects(newPoint, this.boundaries[i]);
                }
            }
        }
    }

    /**
     * Checks for intersection
     * Intersection is defined as being closer to any point than
     * the maximum segment length from any point in the network
     * and not being on the same boundary
     */
    bool intersects(dVector point, PlateBound onBound) {
        foreach(bound; this.boundaries) {
            Queue!dVector temp = new Queue!dVector(); //A temporary queue used to store the current state along the plate bound in the case of an intersection
            Queue!dVector old = bound.points;
            if(onBound !is bound) {
                for(int i = 0; i < bound.points.size; i++) {
                    dVector joint = bound.points.peek();
                    if((point - joint).magnitude < BoundGenConstants.MAX_LENGTH) {
                        onBound.points.enqueue(joint);
                        this.boundaries ~= new PlateBound(temp);
                        onBound.isClosed = true;
                        return true; 
                    }
                    temp.enqueue(bound.points.dequeue);
                }
                bound.points = old;
            }
        }
        return false;
    }

}