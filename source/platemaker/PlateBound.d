module platemaker.PlateBound;

import d2d;
import platemaker;
import std.math;
import std.random;

/**
 * A list of boundary generation constants used
 * in expanding plate boundaries
 */
enum BoundGenConstants {
    LENGTH=0.05,
    ANGLE_VARIATION=PI_4
}

/**
 * A class representing a growing list of segments
 * Acts as an ordered list of vertices that represent segments
 * Performs actions that extend the boundary
 * and is accessed by slice objects
 */
class PlateBound {

    dVector[] vertices; ///The ordered list of points on this boundary
    double prevAngle; ///The previous angle toward which a vertex was placed; used to limit variation
    bool isClosed; ///Whether or not the boundary is closed and can still expand
    int[] slices; ///All of the indices in this boundary slicing it
    bool onEdge; ///Whether or not the bound has hit the edge

    /**
     * Constructs a new PlateBound object
     * Starts with two vertices, one at the location
     * parameter, and one generated in the direction given
     * Also begins with a slice encompassing the entire boundary at this point
     */
    this(dVector location, double angle) {
        this.vertices ~= location;
        this.prevAngle = angle;
        this.appendVertex(angle);
        this.slices ~= 0;
    }

    /**
     * Property that returns the length of the boundary
     * Returns the length of the vertices list
     */
    @property int length() {
        return this.vertices.length;
    }

    /**
     * Appends the given vertex to the list
     * Handles hitting the edge and closing the bound if so
     */
    void appendVertex(dVector vertex) {
        bool hitEdge;
        if(vertex.x > 2) {
            vertex.x = 2;
            hitEdge = true;
        } else if(vertex.x < 0) {
            vertex.x = 0;
            hitEdge = true;
        }
        if(vertex.y > 1) {
            vertex.y = 1;
            hitEdge = true;
        } else if(vertex.y < 0) {
            vertex.y = 0;
            hitEdge = true;
        }
        this.vertices ~= vertex;
        if(hitEdge) {
            this.onEdge = true;
            this.close();
        }
    }

    /**
     * Closes this plate boundary
     */
    void close() {
        this.isClosed = true;
        this.slices ~= this.length - 1;
    }

    /**
     * Adds a new vertex to the boundary, given an angle
     * Uses the bound gen constant length 
     * Creates a unit vector pointed toward the angle,
     * scales the vector by the length of the segment,
     * then adds that vector to the previous vertex to get the new vertex to add
     */
    void appendVertex(double angle) {
        dVector newPoint = new dVector(cos(angle), sin(angle));
        newPoint.magnitude = BoundGenConstants.LENGTH;
        this.appendVertex(this.vertices[this.vertices.length - 1] + newPoint);
        this.prevAngle = angle;
    }

    /**
     * Overload of appendVertex that uses a random angle,
     * based on this boudary's previous angle and the possible
     * angle variation defined in BoundGenConstants
     */
    void appendVertex() {
        this.appendVertex(this.prevAngle + uniform(-cast(double) BoundGenConstants.ANGLE_VARIATION, 
                cast(double) BoundGenConstants.ANGLE_VARIATION));
    }

    /**
     * Adds a slice location to this boundary
     * Moves the slice to a location that
     * follows an ascending order
     */
    void addSlice(int slice) {
        this.slices ~= slice;
        int i = this.slices.length - 1;
        while(i > 0 && this.slices[i-1] > slice) {
            this.slices[i] = this.slices[i-1]; //Shift element forward
            i--;
        }
        this.slices[i] = slice;
    }

}