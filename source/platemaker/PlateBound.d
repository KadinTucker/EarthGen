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
    MIN_LENGTH=0.03,
    MAX_LENGTH=0.1,
    ANGLE_VARIATION=PI_4
}

/**
 * A boundary between two plates
 * Represented by a series of sements
 * Will continue expanding during generation if not closed off
 */
class PlateBound {

    Stack!dVector segments; ///The stack of connected points that make up the boundary
    Stack!double angles; ///The direction of the previous segment
    bool isClosed; ///Whether or not the boundary is itself bounded; by default false

    /**
     * Initializes the plate boundary
     * Takes in the location of the initial point on the planet
     */
    this(double x, double y) {
        this.segments.push(new dVector(x, y));
    }

    /**
     * Appends a randomly generated point to the boundary
     * Generates a random location by creating a unit vector 
     * at a random angle, then scaling it to a randomly determined length
     * between the minimum and maximum as defined.
     */
    void append() {
        double randomAngle = this.getRandomAngle();
        dVector newPoint = new dVector(cos(randomAngle), sin(randomAngle));
        newPoint.magnitude = uniform(cast(double) BoundGenConstants.MIN_LENGTH, cast(double) BoundGenConstants.MAX_LENGTH);
        this.segments.push(newPoint);
        this.angles.push(randomAngle);
    }

    /**
     * Gets a random angle value based on the previous angle
     * and on the possible range of new values 
     * If no previous angles, return completely random angle
     * MAYBE: Strait-weight; take sqrt of deviated value
     */
    private double getRandomAngle() {
        if(this.angles.isEmpty()) {
            return uniform(0, 2 * PI);
        }
        return this.angles.peek() + uniform(-cast(double) BoundGenConstants.ANGLE_VARIATION, cast(double) BoundGenConstants.ANGLE_VARIATION);
    }

}