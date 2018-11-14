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

    Stack!dVector points; ///The stack of connected points that make up the boundary
    Stack!double angles; ///The direction of the previous segment
    int length; ///How many segments compose this bound

    /**
     * Initializes the plate boundary
     * Takes in the location of the initial point on the planet
     */
    this(double x, double y) {
        this.points = new Stack!dVector();
        this.angles = new Stack!double();
        this.points.push(new dVector(x, y));
    }

    /**
     * Alternate constructor taking in a dVector
     */
    this(dVector location) {
        this(location.x, location.y);
    }

    /**
     * Appends a randomly generated point to the boundary
     * Generates a random location by creating a unit vector 
     * at a random angle, then scaling it to a randomly determined length
     * between the minimum and maximum as defined.
     * Returns the new segment appended
     */
    dSegment append() {
        double randomAngle = this.getRandomAngle();
        dVector newPoint = new dVector(cos(randomAngle), sin(randomAngle));
        newPoint.magnitude = uniform(cast(double) BoundGenConstants.MIN_LENGTH, cast(double) BoundGenConstants.MAX_LENGTH);
        dVector prevPoint = this.points.peek();
        this.points.push(newPoint + prevPoint);
        this.angles.push(randomAngle);
        this.length++;
        return new dSegment(this.points.peek(), prevPoint);
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