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
     * TODO:
     */
    this(int numDivisions) {
        double dx = 1.0 / numDivisions;
        for(double lon; lon < 2.0; lon += dx) {
            for(double lat; lon < 1.0; lon += dx) {
                
            }
        }
    }

    /**
     * Generates a random plate network
     * TODO:
     */
    void make() {
        bool segAdded = true;
        while(segAdded) {
            
        }
    }



}