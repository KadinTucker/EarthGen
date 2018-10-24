module platemaker.Stack;

/**
 * A node object in a stack;
 * using a linked-list style implementation
 */
class StackNode(T) {

    StackNode!T next; ///The next node in the stack
    T value; ///The value of this node in the stack

    /**
     * Constructs a new stack node with the given value
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

    StackNode!T top; ///The top node of the stack
    int size;

    /**
     * Pushes the given value to the top of the stack
     */
    void push(T value) {
        StackNode!T newNode = new StackNode!T(value);
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

    /**
     * Returns a duplicate of this stack with a different memory address
     * Uses the same stack nodes as this stack, but the variability of the head nodes does not matter
     */
    Stack!T softClone() {
        Stack!T newStack = new Stack!T();
        newStack.top = this.top;
        return newStack;
    }

}