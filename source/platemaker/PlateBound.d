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
    MIN_LENGTH=0.2,
    MAX_LENGTH=0.5,
    ANGLE_VARIATION=PI_4
}

/**
 * A boundary between two plates
 * Represented by a series of sements
 * Will continue expanding during generation if not closed off
 */
class PlateBound {

    Queue!dVector points; ///The stack of connected points that make up the boundary
    double prevAngle; ///The direction of the previous segment
    int length; ///How many segments compose this bound
    bool isClosed; ///Whether or not the boundary is closed

    /**
     * Initializes the plate boundary
     * Takes in the location of the initial point on the planet
     */
    this(double x, double y) {
        this.points = new Queue!dVector();
        this.prevAngle = uniform(0.0, 2 * PI);
        this.points.enqueue(new dVector(x, y));
    }

    /**
     * Alternate constructor taking in a dVector
     */
    this(dVector location) {
        this(location.x, location.y);
    }

    /**
     * Alternate constructor taking in an existing queue of points
     * Constructor assumes an already closed boundary
     * Previous angle does not matter, since the boundary is closed
     */
    this(Queue!dVector points) {
        this.points = points;
        this.isClosed = true;
        this.length = this.points.size;
    }

    /**
     * Appends a randomly generated point to the boundary
     * Generates a random location by creating a unit vector 
     * at a random angle, then scaling it to a randomly determined length
     * between the minimum and maximum as defined.
     * Returns the new segment appended
     */
    dVector append() {
        double randomAngle = this.getRandomAngle();
        dVector newPoint = new dVector(cos(randomAngle), sin(randomAngle));
        newPoint.magnitude = uniform(cast(double) BoundGenConstants.MIN_LENGTH, cast(double) BoundGenConstants.MAX_LENGTH);
        dVector prevPoint = this.points.peek();
        this.points.enqueue(newPoint + prevPoint);
        this.prevAngle = randomAngle;
        this.length++;
        return this.points.peek();
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

}