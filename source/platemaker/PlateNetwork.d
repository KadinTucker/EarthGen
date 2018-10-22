module platemaker.PlateNetwork;

import std.random;
import d2d;
import platemaker;

/**
 * An object which creates and stores tectonic plate networks
 */
class PlateNetwork {

    double[2] junctions; ///A list of each junction between plate boundaries
    PlateBound[] boundaries; ///A list of every plate boundary

    /**
     * Initalizes a new PlateNetwork
     * Begins with uniformly (with noise) distributed loci for triple junctions
     * Uses a "planet" that is twice as wide as it is tall (like a rectagular mapping of Earth)
     * TODO:
     */
    this(int numDivisions) {
        //Create square areas with which to distribute the intial boundaries
        //Makes for a semi-uniformly distributed range of junctions
        //TODO: make junctions better spaced?
        double dx = 1.0 / numDivisions;
        for(double x; x < 2.0; x += dx) {
            for(double y; y < 1.0; y += dx) {
                
            }
        }
    }

    /**
     * Generates a random plate network
     * TODO:
     */
    void make() {
        
    }

    /**
     * Extends all actively growing plate boundaries
     * TODO:
     */
    void extendBoundaries() {

    }

}