# The Standard Queue #

The standard Queue is a First in First out (FIFO) or Last in First Out (LIFO) ordered collection that uses an internal Array to store the content of the item. Items are stored in the order they are added and the returned based on the sort order direction for the queue.  The Queue offers the ability to both reorder the queue by removing items and then adding items at specific places and has other convenience methods to verify the number of items in the queue or if queue contains any items.

## The Basics ##

When a Queue is created a direction argument is passed in that defines how the queue will retrieve items. By default the queue is FIFO based (FIFO/LIFO will be explained shortly):

```
// create a LIFO Queue
var myLIFOQueue:Queue = new Queue(Queue.LIFO);

// create a FIFO Queue
var myFIFOQueue:Queue = new Queue();
```

The next step is to start adding items to the queue by using either the `add()` method or the `addAt()` method.  In most cases you will use the simple `add()` command to store items in the queue:

```
// create the queue
var myQueue:Queue = new Queue();

// add items
myQueue.add({name: "itemOne"});
myQueue.add({name: "itemTwo"});
myQueue.add({name: "itemThree"});
myQueue.add({name: "itemFour"});
```

### Using `next()` and `last()` ###

Once items are added to a queue, you can then retrieve them using the `next()` or `last()` method.  The retrieval methods differ in functionality based on direction of the queue.  In our above example, our queue is set to the default FIFO direction.  This means that the first item added, "itemOne" will be retrieved when `next()` is called, because FIFO means "first in first out".  Since "itemOne" was the first item added to the queue it will be the first item returned when `next()` is called.  When `last()` is called "itemFour" is returned because it was the last item added to the queue:

```
// call next
trace(myQueue.next().name); // Output: itemOne

// call last
trace(myQueue.last().name); // Output: itemFour
```

When `next()` and `last()` are used with a LIFO sort ordered queue, their functionality switches from a FIFO queue. This is due to how LIFO order works, "last in first out" means that when `next()` is called the last item added to the queue will be the first item out:

```
// create the queue
var myQueue:Queue = new Queue(Queue.LIFO);
// add items
...

// call next
trace(myQueue.next().name); // Output: itemFour

// call last
trace(myQueue.last().name); // Output: itemOne
```

When using `next()` and `last()` it is important to know that these are transfigurative methods.  When an item is returned from the `next()` call the queue is altered and no longer contains the item that was returned:

```
trace(myQueue.next().name); // Output: itemOne
trace(myQueue.next().name); // Output: itemTwo
trace(myQueue.next().name); // Output: itemThree
trace(myQueue.next().name); // Output: itemFour
```

### Modifying The Queue ###
The Queue has multiple helper methods to enable modification of the queue before retrieval of items.  The first method is the `addAt()` call.  This method allows you to add items to a specific position in the queue after items have already been added.  By default `addAt()` always adds items to the zero position of the queue (first if FIFO, last if LIFO) if no position value is provided.  If a value is provided the queue attempts to place and re-order the queue around the new item.  If the position value is equal to or greater then the length of the queue the the item is added to _n_ position of the queue (last if FIFO, first if LIFO). _Note:_ the sort order of the queue is zero based, just like an Array:

```
// create the queue
var myQueue:Queue = new Queue();

// add items
myQueue.add({name: "itemOne"});
myQueue.add({name: "itemTwo"});
myQueue.add({name: "itemThree"});

// use addAt() to add to the 2nd position
myQueue.addAt({name: "itemFour"}, 1);

// call next
trace(myQueue.next().name); // Output: itemOne
trace(myQueue.next().name); // Output: itemFour
```

The Queue also has helper methods to remove items from the data structure.  The first method is `remove()` which uses an item as a key to look for and then remove the exiting item from the queue.  It is possible to have the same item multiple times, in different positions, in the same queue.  The `remove()` method takes a count argument that determines how many instances of the item should be removed from the queue.  In some cases it may be desirable to remove only the first instance but keep the rest.  By default, `remove()` will remove all instances from the queue unless a count specifier is provided. _Note:_ The remove count is not zero based like `add()`, the count value is the number of items to remove:

```
// create the queue
var myQueue:Queue = new Queue();

// add items
var myItemOne:Object = {name: "itemOne"};
var myItemTwo:Object = {name: "itemTwo"};

myQueue.add(myItemTwo);
myQueue.add(myItemOne);
myQueue.add(myItemTwo);

// use remove() to get rid of the first instance
myQueue.remove(myItemTwo, 1);

// call next
trace(myQueue.next().name); // Output: itemOne
trace(myQueue.next().name); // Output: itemTwo
```

The Queue also has the ability to remove an item at a specified position in the queue, by using `removeAt()`.  _Note:_ `removeAt() is zero based just like `addAt()`:

```
// create the queue
var myQueue:Queue = new Queue();

// add items
var myItemOne:Object = {name: "itemOne"};
var myItemTwo:Object = {name: "itemTwo"};

myQueue.add(myItemTwo);
myQueue.add(myItemOne);
myQueue.add(myItemTwo);

// use remove() to get rid of the first instance
myQueue.removeAt(1);

// call next
trace(myQueue.next().name); // Output: itemTwo
trace(myQueue.next().name); // Output: itemTwo
```

The Queue also has other helper methods/propeties, such as `removeAll()`, `hasItems` and `length` that enable easier manipulation of the queue.

```
// create the queue
var myQueue:Queue = new Queue();

// add items
myQueue.add({name: "itemOne"});
myQueue.add({name: "itemTwo"});
myQueue.add({name: "itemThree"});

// verify the queue has items and the length
trace(myQueue.hasItems); // Output: true
trace(myQueue.length); // Output: 3

// remove all the items and then verify
myQueue.removeAll();
trace(myQueue.hasItems); // Output: false
trace(myQueue.length); // Output: 0
```

## Considerations ##

With any API/Data set there are always considerations that need to be made when using the technology.  Its always better to know about these potential issues before hand, rather then implementing the technology and then realizing it does not behave the way that was originally intended.

  * The Queue uses an Array to store the content.  This means that items in the Queue have a strong reference and will not be Garbage Collected if the Queue is the only reference to the object instance.  Always remove items from a queue to enable GC.
  * `addAt()` and `removeAt()` ignores the queue sort order type and ALWAYS starts at the zero position of the internal array.  This can sometimes cause confusion when using a LIFO sort ordered queue because `addAt(0)` means add at the "last" position not the "next" position.