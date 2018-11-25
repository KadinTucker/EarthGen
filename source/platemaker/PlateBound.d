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
    MIN_LENGTH=0.02,
    MAX_LENGTH=0.05,
    ANGLE_VARIATION=PI_4
}

/**
 * A class representing a turning point on a boundary
 * Contains a pointer to the next point on the boundary,
 * and an actual location value
 * Acts as a linked list node for a plate boundary
 */
class BoundJoint {

    BoundJoint next; ///The next joint in the series of boundary joint
    dVector location; ///The location of the bound joint as a point

    /**
     * Creates a new boundary joint at the given location
     * The next joint is, by default, null
     */
    this(dVector location) {
        this.location = location;
    }

}

/**
 * A boundary between two plates
 * Represented by a linked list implementation of boundary joints
 * Will continue expanding during generation if not closed off
 */
class PlateBound {

    BoundJoint initial; ///The initial point of the boundary; points through a series to the end
    BoundJoint terminal; ///The final, most recently added point on the boundary
    int length; ///The number of joints on this boundary
    double prevAngle; ///The direction of the previous segment relative to the angle 0 as regularly defined
    bool isClosed; ///Whether or not the boundary is closed

    /**
     * Initializes the plate boundary
     * Takes in the location of the initial point on the planet
     */
    this(double x, double y) {
        this.prevAngle = uniform(0.0, 2 * PI);
        this.initial = new BoundJoint(new dVector(x, y));
        this.terminal = this.initial;
    }

    /**
     * Alternate constructor, taking in a terminal and initial point, an isClosed value, and the previous angle
     */
    this(BoundJoint initial, BoundJoint terminal, bool closed, double prevAngle) {
        this.initial = initial;
        this.terminal = terminal;
        this.isClosed = closed;
        this.prevAngle = prevAngle;
    }

    /**
     * Adds a bound joint to the end of the boundary
     * Works as a normal linked list append
     */
    void add(BoundJoint joint) {
        this.terminal.next = joint;
        this.terminal = joint;
        this.length++;
    }

    /**
     * Appends a randomly generated point to the boundary
     * Generates a random location by creating a unit vector 
     * at a random angle, then scaling it to a randomly determined length
     * between the minimum and maximum as defined in the constants
     */
    void append() {
        double randomAngle = this.getRandomAngle();
        dVector newPoint = new dVector(cos(randomAngle), sin(randomAngle));
        newPoint.magnitude = uniform(cast(double) BoundGenConstants.MIN_LENGTH, cast(double) BoundGenConstants.MAX_LENGTH);
        dVector prevPoint = this.terminal.location;
        this.add(new BoundJoint(newPoint + prevPoint));
        this.prevAngle = randomAngle;
    }

    /**
     * Gets a random angle value based on the previous angle
     * and on the possible range of new values 
     * If no previous angles, return completely random angle
     * MAYBE: Strait-weight; take sqrt of deviated value
     */
    private double getRandomAngle() {
        return this.prevAngle + uniform(-cast(double) BoundGenConstants.ANGLE_VARIATION, cast(double) BoundGenConstants.ANGLE_VARIATION);
    }

    override string toString() {
        string str = " ";
        BoundJoint node = this.initial;
        while(node !is null) {
            str ~= node.location.toString;
            if(node.next !is null) str = str ~ " -> "; 
            node = node.next;
        }
        return str;
    }

}