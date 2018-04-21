module platemaker.PlateBound;

import d2d;

/**
 * A boundary between two plates
 * Represented by a series of sements
 * Will continue expanding during generation if not closed off
 */
class PlateBound {

    dSegment[] segments; ///The segments that make up the boundary
    bool isClosed; ///Whether or not the boundary is itself bounded

}