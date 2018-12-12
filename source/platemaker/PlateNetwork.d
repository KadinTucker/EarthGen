module platemaker.PlateNetwork;

import std.algorithm;
import std.math;
import std.random;
import d2d;
import platemaker;

/**
 * An object which creates and stores tectonic plate networks
 */
class PlateNetwork {

    PlateBound[] allBounds; ///All of the plate boundaries in this network

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
                dVector location = new dVector(uniform(x, x + boundSize), uniform(y, y + boundSize));
                //Creates bounds that each point 120 degrees away from each other
                for(double i = 0; i < 2 * PI; i += 2 * PI / 3) {
                    this.allBounds ~= new PlateBound(location, i);
                }
            }
        }
        //this.make();
    }

    /**
     * Generates a random plate network
     * Acts as the main method
     * Runs all of the components of the generation algorithm
     */
    void make() {
        this.genBoundaries();
    }

    /**
     * Generates the boundaries of the plate network
     */
    void genBoundaries() {
        bool loop = true;
        while(loop) {
            loop = false;
            foreach(bound; this.allBounds) {
                if(!bound.isClosed) {
                    loop = true; //continue if there exists an open bound
                    bound.appendVertex();
                    this.intersects(); //Check for any intersections
                }
            }
        }
    }

    /**
     * Extends all open boundaries on the network
     * For testing purposes
     */
    void extendBoundaries() {
        foreach(bound; this.allBounds) {
            if(!bound.isClosed) {
                bound.appendVertex();
                this.intersects(); //Check for any intersections
            }
        }
    }

    /**
     * Checks for intersection between all new vertices and existing vertices
     * Intersection is defined as being closer to any point than
     * the maximum segment length from any point in the network
     * and not being on the same boundary
     * Uses the newest vertices, the ones on the ends of the boundaries
     */
    void intersects() {
        foreach(bound; this.allBounds) {
            if(!bound.isClosed && bound.length > 2) { //Bound longer than 2, since otherwise starting bounds will intersect
                foreach(otherBound; this.allBounds) {
                    if(bound != otherBound) {
                        for(int i = 0; i < otherBound.length; i++) {
                            //If the distance between vertices is less than segment length
                            //Uses vector operations to determine distance
                            if((otherBound.vertices[i] - bound.vertices[bound.length - 1]).magnitude < BoundGenConstants.LENGTH) {
                                //Intersection has occurred
                                bound.appendVertex(otherBound.vertices[i]);
                                otherBound.slices ~= i;
                                bound.isClosed = true;
                            }
                        }
                    }
                }
            }
        }
    }

}