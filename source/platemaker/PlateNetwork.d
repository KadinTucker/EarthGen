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
    dVector[] allJoints; ///A list of all of the joints, used to check for intersections

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
        foreach(bound; this.boundaries) {
            if(!bound.isClosed) {
                this.allJoints ~= bound.append();
                if(bound.length > 1 && this.intersects(this.allJoints[this.allJoints.length - 1], bound)) {
                    bound.isClosed = true;
                }
            }
        }
    }

    /**
     * Checks for intersection
     * Intersection is defined as being within some fraction
     * of the minimum segment length from any joint
     */
    bool intersects(dVector point, PlateBound bound) {
        foreach(joint; this.allJoints) {
            if(point !is joint && (point - joint).magnitude < BoundGenConstants.MIN_LENGTH) {
                bound.points.push(joint);
                return true; 
            }
        }
        return false;
    }

}