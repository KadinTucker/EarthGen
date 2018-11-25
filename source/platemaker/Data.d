module platemaker.Data;

/**
 * A node object in a data structure that;
 * uses a linked-list style implementation
 * Stores a templated value as well as a pointer to the next 
 * node in the sequence as defined by the data structure
 */
class Node(T) {

    Node!T next; ///The next node in the data structure
    T value; ///The value of this node in the data structure

    /**
     * Constructs a new node with the given value
     * Next is by default null
     */ 
    this(T value) {
        this.value = value;
    }

}

/**
 * A templated implementation of a Stack data structure
 */
class Stack(T) {

    Node!T top; ///The top node of the stack
    int size;

    /**
     * Pushes the given value to the top of the stack
     */
    void push(T value) {
        Node!T newNode = new Node!T(value);
        newNode.next = this.top;
        this.top = newNode;
        this.size += 1;
    }

    /**
     * Returns the value of the top node
     */
    T peek() {
        return this.top.value;
    }

    /**
     * Removes the first item from the stack and returns its value
     */
    T pop() {
        if(this.isEmpty()) {
            throw new Exception("Stack empty");
        }
        T toReturn = this.top.value;
        this.top = this.top.next;
        this.size -= 1;
        return toReturn;
    }

    /**
     * Returns whether or not the stack is empty
     */
    bool isEmpty() {
        return this.top is null;
    }

}

/**
 * A queue object, using a linked list implementation
 * Is a first-in-first-out data structure
 */
class Queue(T) {

    Node!T top; ///The top of the queue; the next item to go out
    Node!T bottom; ///The bottom of the queue; the most recent item that came in
    int size; ///The number of items in the queue

    /**
     * Adds to the bottom of the queue the given item
     */
    void enqueue(T value) {
        Node!T newNode = new Node!T(value);
        if(this.bottom is null) this.bottom = newNode;
        else {
            this.bottom.next = newNode;
            this.bottom = newNode;
            this.size += 1;
        }
        if(this.top is null) this.top = newNode;
    }

    /**
     * Returns the value of the top node
     */
    T peek() {
        if(this.isEmpty()) {
            throw new Exception("Queue empty");
        }
        return this.top.value;
    }

    /**
     * Removes the top item of the queue and returns its value
     */
    T dequeue() {
        if(this.isEmpty()) {
            throw new Exception("Queue empty");
        }
        T toReturn = this.top.value;
        this.top = this.top.next;
        this.size -= 1;
        return toReturn;
    }

    /**
     * Dequeues the top and adds the item to the bottom for the purpose of iteration
     * More efficient than dequeuing and enqueuing manually
     */
    void iterate() {
        this.bottom.next = this.top;
        this.bottom = this.top;
        this.top = this.top.next;
    }

    /**
     * Returns whether or not the queue is empty
     */
    bool isEmpty() {
        return this.top is null;
    }
    
}