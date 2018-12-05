module platemaker.PlateNetwork;

import std.algorithm;
import std.random;
import d2d;
import platemaker;

/**
 * An object which creates and stores tectonic plate networks
 */
class PlateNetwork {

    EndJoint[] endNodes; ///A list of the end nodes of every plate boundary
    int nodesLeft; ///How many end nodes remain active
    BoundJoint[] allJoints; ///A list of every joint in the network

    /**
     * Initalizes a new PlateNetwork
     * Begins with uniformly (with noise) distributed loci for triple junctions
     * Uses a "planet" that is twice as wide as it is tall (like a rectagular mapping of Earth)
     * numDivisions is equal to the number of starting boundary locations
     */
    this(int numDivisions) {
        //Create square areas with which to distribute the intial boundaries 
        double boundSize = 1.0 / numDivisions;
        for(double x = 0.0; x < 2.0; x += 2 * boundSize) {
            for(double y = 0.0; y < 1.0; y += boundSize) {
                TripleJoint triple = new TripleJoint(new dVector(uniform(x, x + boundSize), uniform(y, y + boundSize)));
                this.allJoints ~= triple;
                //Adds all of the end joints on the triple joint to the appropriate lists
                for(int i = 0; i < 3; i++) {
                    this.endNodes ~= cast(EndJoint) triple.connectedTo[i];
                    this.allJoints ~= triple.connectedTo[i];
                }
            }
        }
        this.nodesLeft = this.endNodes.length;
        this.make();
    }

    /**
     * Generates a random plate network
     * Acts as the main method, of sorts
     */
    void make() {
        while(this.nodesLeft > 0) {
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
        foreach(end; this.endNodes) {
            if(!end.closed) {
                end.transform(this);
                this.intersects(end);
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
    bool intersects(EndJoint end) {
        foreach(joint; this.allJoints) {
            if(joint !is end.prevJoint && end.distance(joint) < BoundGenConstants.MAX_LENGTH) {
                InterJoint appended = new InterJoint(end);
                this.allJoints ~= appended;
                if(cast(InterJoint) end.prevJoint) {
                    (cast(InterJoint) end.prevJoint).nextJoint = appended;
                }
                if(cast(InterJoint) joint) {
                    this.allJoints ~= new TripleJoint(cast(InterJoint) joint, appended);
                }
                this.nodesLeft -= 1;
                end.closed = true;
            }
        }
        return false;
    }

}