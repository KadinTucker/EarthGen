module platemaker.PlateNetwork;

import std.array;
import std.conv;
import std.file;
import std.math;
import std.random;
import d2d;
import platemaker;

/**
 * An object which creates and stores tectonic plate networks
 */
class PlateNetwork {

    PlateBound[] allBounds; ///All of the plate boundaries in this network
    dVector[][] slices; ///All of the slices in the network; null until finished

    /**
     * Initalizes a new PlateNetwork
     * Begins with uniformly (with noise) distributed loci for triple junctions
     * Uses a "planet" that is twice as wide as it is tall (like a rectagular mapping of Earth)
     * numDivisions is equal to the number of starting boundary locations
     */
    this(int numDivisions) {
        //Create square areas with which to distribute the intial boundaries 
        double boundSize = 1.0 / numDivisions;
        for(double x = 0.0; x < 2.0; x += 2 * boundSize) {
            for(double y = 0.0; y < 1.0; y += boundSize) {
                dVector location = new dVector(uniform(x, x + boundSize), uniform(y, y + boundSize));
                //Creates bounds that each point 120 degrees away from each other
                for(double i = 0; i < 2 * PI; i += 2 * PI / 3) {
                    this.allBounds ~= new PlateBound(location, i);
                }
            }
        }
        //this.make();
    }

    /**
     * Alternate constructor, which, instead of making from scratch,
     * takes pre-existing data from a file
     * Assumes that the plate from file has finished generation 
     */
    this(string filename) {
        string data = readText(filename);
        string[] lines = data.split("\n");
        foreach(line; lines) {
            dVector[] slice;
            string[] vertices = line.split("/");
            foreach(vertex; vertices) {
                string[] components = vertex.split(",");
                slice ~= new dVector(components[0].to!double, components[1].to!double);
            }
            this.slices ~= slice;
        }
    }

    /**
     * Generates a random plate network
     * Acts as the main method
     * Runs all of the components of the generation algorithm
     */
    void make() {
        this.genBoundaries();
    }

    /**
     * Generates the boundaries of the plate network
     */
    void genBoundaries() {
        bool loop = true;
        while(loop) {
            loop = false;
            foreach(bound; this.allBounds) {
                if(!bound.isClosed) {
                    loop = true; //continue if there exists an open bound
                    bound.appendVertex();
                    this.intersects(); //Check for any intersections
                }
            }
        }
    }

    /**
     * Gets all of the slices in the network
     * A slice is represented as a list of dVector vertices
     */
    dVector[][] getAllSlices() {
        dVector[][] allSlices;
        foreach(bound; this.allBounds) {
            for(int i = 1; i < bound.slices.length; i++) {
                dVector[] slice;
                for(int j = bound.slices[i - 1]; j <= bound.slices[i]; j++) {
                    slice ~= bound.vertices[j];
                }
                if(slice.length > 0) allSlices ~= slice;
            }
        }
        return allSlices;
    }

    /**
     * Exports the plate network, all of its slices, to a file
     * The data are stored as the list of all slices,
     * with commas between corresponding x and y coordinates,
     * and forward slashes between each vertex
     * Each slice goes on a different line
     */
    void exportPlates(string filename) {
        string data = "";
        dVector[][] allSlices = this.getAllSlices();
        for(int i = 0; i < allSlices.length; i++) {
            for(int j = 0; j < allSlices[i].length; j++) {
                data ~= allSlices[i][j].x.to!string;
                data ~= ",";
                data ~= allSlices[i][j].y.to!string;
                if(j < allSlices[i].length - 1) data ~= "/";
            }
            if(i < allSlices.length -1) data ~= "\n";
        }
        std.file.write(filename, data);
    }

    /**
     * Extends all open boundaries on the network
     * For testing purposes
     */
    void extendBoundaries() {
        bool finished = true;
        foreach(bound; this.allBounds) {
            if(!bound.isClosed) {
                finished = false;
                bound.appendVertex();
                this.intersects(); //Check for any intersections
            }
        }
        if(finished) {
            this.slices = this.getAllSlices();
        }
    }

    /**
     * Checks for intersection between all new vertices and existing vertices
     * Intersection is defined as being closer to any point than
     * the maximum segment length from any point in the network
     * and not being on the same boundary
     * Uses the newest vertices, the ones on the ends of the boundaries
     */
    void intersects() {
        foreach(bound; this.allBounds) {
            if(!bound.isClosed && bound.length > 2) { //Bound longer than 2, since otherwise starting bounds will intersect
                foreach(otherBound; this.allBounds) {
                    if(bound != otherBound) {
                        for(int i = 0; i < otherBound.length; i++) {
                            //If the distance between vertices is less than segment length
                            //Uses vector operations to determine distance
                            if((otherBound.vertices[i] - bound.vertices[bound.length - 1]).magnitude < BoundGenConstants.LENGTH) {
                                //Intersection has occurred
                                bound.appendVertex(otherBound.vertices[i]);
                                otherBound.addSlice(i);
                                bound.close();
                            }
                        }
                    }
                }
            }
        }
    }

}