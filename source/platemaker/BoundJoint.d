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
 * A class representing a vertex on a plate network
 * Bound joints have three different forms, depending on how many connections they have
 * All bound joints have a location on the graph representing the plate network
 * Can get the distance from another bound joint
 */
class BoundJoint {

    dVector location; ///The location of the bound joint as a point

    /**
     * Creates a new boundary joint at the given location
     * Default constructor
     * Causes wraparound; top and bottom rebound, left and right transfer to other side
     */
    this(dVector location) {
        this.location = location;
        if(this.location.x > 2) {
            this.location.x = 2 - this.location.x;
        } else if(this.location.x < 0) {
            this.location.x = 2 + this.location.x; 
        } else if(this.location.y > 1) {
            this.location.y = this.location.y - 2 * (this.location.y -1);
        } else if(this.location.y < 0) {
            this.location.y *= -1; 
        }
    }

    /**
     * Gets the distance between this bound joint and another
     * Uses d2d vector operations to get the distance
     */
    double distance(BoundJoint other) {
        return (this.location - other.location).magnitude;
    }

    /**
     * Gets the direction angle of the line passing through two joints
     */
    double directionAngle(BoundJoint other) {
        return atan2(this.location.x - other.location.x, this.location.y - other.location.y) + PI;
    }

}

/**
 * A bound joint that connects to only one other
 * Can transform itself, and by doing so adds itself to a chain of joints
 */
class EndJoint : BoundJoint {

    double previousAngle; ///The direction which the previous extension went in
    BoundJoint prevJoint; ///The single joint to which this joint is connected
    bool closed; ///Whether or not this end joint is closed off

    /**
     * Constructor; in addition to taking in location, takes in the previous angle and the origin
     */
    this(dVector location, double previousAngle) {
        super(location);
        this.previousAngle = previousAngle;
    }

    /**
     * Moves the end joint, and leaves behind an inter joint
     * Checks for intersections in the network, and adds the inter joint's location to the network
     */
    void transform(PlateNetwork network) {
        //Create an inter joint at the current location
        //Set the prior joint's next joint to be the new joint added
        InterJoint leftBehind = new InterJoint(this);
        if(cast(InterJoint) this.prevJoint) {
            (cast(InterJoint) this.prevJoint).nextJoint = leftBehind;
        }
        this.prevJoint = leftBehind;
        //Get the shift induced by adding a new vertex
        double randomAngle = this.previousAngle + uniform(-cast(double) BoundGenConstants.ANGLE_VARIATION, cast(double) BoundGenConstants.ANGLE_VARIATION);
        dVector newPoint = new dVector(cos(randomAngle), sin(randomAngle));
        newPoint.magnitude = BoundGenConstants.MAX_LENGTH;
        this.location += newPoint;
        this.previousAngle = randomAngle;
    }

}

/**
 * An intermediate joint in a series of joints
 */
class InterJoint : BoundJoint {

    BoundJoint prevJoint; ///The previous joint in the series
    BoundJoint nextJoint; ///The next joint in the series

    /**
     * Constructor, constructs from a previously existing end joint
     */
    this(EndJoint end) {
        super(end.location);
        this.prevJoint = end.prevJoint;
    }

    /**
     * Constructs an intermediate joint from just a location
     */
    this(dVector location) {
        super(location);
    }

}

/**
 * A triple joint, connected to three other joints
 */
class TripleJoint : BoundJoint {

    BoundJoint[3] connectedTo; ///The joints immediately connected to this joint

    /**
     * Constructor for an initial triple joint, that acts as the starting point for three end joints
     */
    this(dVector location) {
        super(location);
        connectedTo[0] = new EndJoint(location + new dVector(-BoundGenConstants.MIN_LENGTH, -BoundGenConstants.MIN_LENGTH), 3 * PI_4);
        connectedTo[1] = new EndJoint(location + new dVector(BoundGenConstants.MIN_LENGTH, -BoundGenConstants.MIN_LENGTH), PI_4);
        connectedTo[2] = new EndJoint(location + new dVector(0, BoundGenConstants.MAX_LENGTH), 3 * PI_2);
    }

    /**
     * Constructor involving an intersection
     * Takes in the inter joint hit, and the inter joint interceding
     */
    this(InterJoint hit, InterJoint interceding) {
        super(hit.location);
        connectedTo[0] = hit.prevJoint;
        connectedTo[1] = hit.nextJoint;
        connectedTo[2] = interceding;
        this.sortConnected();
    }

    /**
     * Sorts the connected bound joints in a counter-clockwise fashion
     * Allows for finding relative directions based on approach from another joint
     */ 
    void sortConnected() {
        for(int i = 0; i < 3; i++) {
            if(this.directionAngle(this.connectedTo[i % 2]) > this.directionAngle(this.connectedTo[i % 2 + 1])) {
                BoundJoint temp = this.connectedTo[i % 2 + 1];
                this.connectedTo[1] = this.connectedTo[i % 2];
                this.connectedTo[0] = temp;
            }
        }
    }

}