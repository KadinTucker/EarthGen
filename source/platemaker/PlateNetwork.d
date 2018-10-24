module platemaker.PlateNetwork;

import std.random;
import d2d;
import platemaker;

/**
 * An object which creates and stores tectonic plate networks
 */
class PlateNetwork {

    dVector[] junctions; ///A list of each junction between plate boundaries
    PlateBound[] boundaries; ///A list of every plate boundary

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
        for(double x; x < 2.0; x += boundSize) {
            for(double y; y < 1.0; y += boundSize) {
                //Runs thrice in order to have the boundary extend in three directions; inits a junction
                dVector location = new dVector(uniform(x, x + boundSize), uniform(y, y + boundSize));
                foreach(i; 0..3) this.boundaries ~= new PlateBound(location.x, location.y);
                this.junctions ~= location;
            }
        }
    }

    /**
     * Generates a random plate network
     * Acts as the main method, of sorts
     * TODO:
     */
    void make() {
        
    }

    /**
     * Extends all actively growing plate boundaries
     * TODO:
     */
    void extendBoundaries() {
        foreach(bound; this.boundaries) {
            if(!bound.isClosed) {
                bound.append();
            }
        }
    }

}