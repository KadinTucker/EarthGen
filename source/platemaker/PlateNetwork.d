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
    dSegment[] allSegments; ///A list of all segments, used to check for intersections

    /**
     * Initalizes a new PlateNetwork
     * Begins with uniformly (with noise) distributed loci for triple junctions
     * Uses a "planet" that is twice as wide as it is tall (like a rectagular mapping of Earth)
     * numDivisions is equal to the number of starting boundary locations
     */
    this(int numDivisions) {
        //Create square areas with which to distribute the intial boundaries 
        //TODO: make loci better spacing with weight toward closer to the centers?
        PlateBound[] openBoundaries;
        double boundSize = 1.0 / numDivisions;
        for(double x = 0.0; x < 2.0; x += 2 * boundSize) {
            for(double y = 0.0; y < 1.0; y += boundSize) {
                //Runs thrice in order to have the boundary extend in three directions; inits a junction
                dVector location = new dVector(uniform(x, x + boundSize), uniform(y, y + boundSize));
                foreach(i; 0..3) openBoundaries ~= new PlateBound(location.x, location.y);
                this.junctions ~= location;
            }
        }
        this.make(openBoundaries);
    }

    /**
     * Generates a random plate network
     * Acts as the main method, of sorts
     * TODO:
     */
    void make(PlateBound[] openBoundaries) {
        //Currently a mode just as a test
        //Runs extend boundaries six times
        foreach(i; 0..12) {
            extendBoundaries(openBoundaries);
        }
        //Place all boundaries that didn't close into boundaries
        foreach(bound; openBoundaries) {
            this.boundaries ~= bound;
        }
        std.stdio.writeln("finished");
    }

    /**
     * Extends all actively growing plate boundaries
     * Runs the boundaries' append method, and checks if
     * the appended location causes an intersection
     * If so, closes the boundary
     */
    void extendBoundaries(PlateBound[] openBoundaries) {
        foreach(bound; openBoundaries) {
            this.allSegments ~= bound.append();
            if(bound.length > 1 && this.intersectsExisting(getRectFromSeg(this.allSegments[this.allSegments.length - 1]))) {
                this.boundaries ~= bound;
                openBoundaries.remove(openBoundaries.countUntil(bound));
            }
        }
    }

    bool intersectsExisting(dRectangle seg) {
        foreach(segment; allSegments) {
            if(intersects(seg, getRectFromSeg(segment))) {
                std.stdio.writeln("intersection found");
                return true;
            }
        }
        return false;
    }

    /**
     * Returns whether the two given segments intersect
     */
    bool intersects(dRectangle seg1, dRectangle seg2) {
        double m1 = seg1.extent.y / seg1.extent.x;
        double m2 = seg2.extent.y / seg2.extent.x;
        if(m1 == m2) {
            return false; //For our purposes, segments on top of each other will not be considered to be intersecting
        }
        double x = (m1 * seg1.initialPoint.x - m2 * seg2.initialPoint.x - seg1.initialPoint.y + seg2.initialPoint.y)
                / (m1 - m2);
        //std.stdio.write("y = "); std.stdio.write(m1); std.stdio.write("x + "); std.stdio.writeln(seg1.initialPoint.y + seg1.initialPoint.x);
        //std.stdio.write("y = "); std.stdio.write(m2); std.stdio.write("x + "); std.stdio.writeln(seg2.initialPoint.y + seg2.initialPoint.x);
        //std.stdio.write("x = "); std.stdio.writeln(x);
        if(x >= min(seg1.initialPoint.x, seg1.initialPoint.x + seg1.extent.x, 
                seg1.initialPoint.y, seg1.initialPoint.y + seg1.extent.y) 
                && x <= max(seg1.initialPoint.x, seg1.initialPoint.x + seg1.extent.x, 
                seg1.initialPoint.y, seg1.initialPoint.y + seg1.extent.y)) {
            std.stdio.writeln("intersection found");
            return true;
        }
        return false;
    }

    dRectangle getRectFromSeg(dSegment segment) {
        return new dRectangle(segment.initial.x, segment.initial.y, segment.terminal.x, segment.terminal.y);
    }

}