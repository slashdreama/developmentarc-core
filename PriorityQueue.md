# The PriorityQueue #

The PriorityQueue is a sort ordered queue based on a specified priority assigned to the item when it is added to the queue.  When an item is added, the queue handles looking at existing items, evaluates their priority value and then re-sorts the queue based on the give priorities of the new item and the existing items.  Higher priority items are always kept at the top of the queue and lower priority items are kept at the end of the queue.  Unlike the standard [Queue](QueueDataStructure.md), the PriorityQueue does not have a direction value, all sorting and retrieval are based on the assigned priority value.

## The Basics ##
As mentioned in the introduction, adding items to a PriorityQueue requires assigning a priority value to the item.  This value is an unsigned integer ranging from 0 to `uint.MAX_VALUE`.  When assigning a priority, the lower the value the higher the priority.  This means that an item with a 0 priority will always go before an item with a 5 priority or a `uint.MAX_VALUE` priority.  The default priority value is 5 when adding an item to the queue.

```
// create the queue
var pQueue:PriorityQueue = new PriorityQueue();

// create some items
var itemOne:Object = {name: "itemOne"};
var itemTwo:Object = {name: "itemTwo"};
var itemThree:Object = {name: "itemThree"};

// add them to the queue
pQueue.addItem(itemOne); // defaulted to priority 5
pQueue.addItem(itemTwo, uint.MAX_VALUE); // lowest priority
pQueue.addItem(itemThree, 0); // highest priority
```

Once items have been added to the PriorityQueue and sorted by priority, you retrieve the items using the `next()` method.  Like the standard [Queue](QueueDataStructure.md), the `next()` method is a transfigurative method.  When an item is returned from the `next()` call the PriorityQueue is altered and no longer contains the item that was returned.  Using the above example to configure the PriorityQueue, `next()` returns like this:

```
// return the items
trace(pQueue.next().name); //  Output: itemThree
trace(pQueue.next().name); //  Output: itemOne
trace(pQueue.next().name); //  Output: itemTwo
```

Looking at the return order you can see how the items where prioritized.  ItemThree had the highest priority and is returned first, itemOne was the next item and itemTwo was the lowest priority.

### More Ordering Examples ###
When items are added of the same priority, the PriorityQueue sorts them in the order they where added.  So if itemFour was set to priority 0 and added, next itemThree was set to priority 0 and added, itemFour would be returned before itemThree, since it was added first. Also, as with any Queue, you can add multiple instances of the same item in the queue and mix and match priority:

```
// create the queue
var pQueue:PriorityQueue = new PriorityQueue();

// create some items
var itemOne:Object = {name: "itemOne"};
var itemTwo:Object = {name: "itemTwo"};
var itemThree:Object = {name: "itemThree"};
var itemFour:Object = {name: "itemFour"};

// add them to the queue
pQueue.addItem(itemOne); // defaulted to priority 5
pQueue.addItem(itemFour, 0); // highest priority
pQueue.addItem(itemTwo, uint.MAX_VALUE); // lowest priority
pQueue.addItem(itemThree, 0); // highest priority
pQueue.addItem(itemFour); // default priority

// return the items
trace(pQueue.next().name); //  Output: itemFour
trace(pQueue.next().name); //  Output: itemThree
trace(pQueue.next().name); //  Output: itemOne
trace(pQueue.next().name); //  Output: itemFour
trace(pQueue.next().name); //  Output: itemTwo
```

Notice how itemFour is used twice with different priority values, also as described above, itemFour with a priority of zero comes before itemThree due to the order added.

### Managing The Queue ###
Like the standard [Queue](QueueDataStructure.md), the PriorityQueue has the ability to remove items once they have been added.  There are three remove methods: `removeItem()`, removeAt() and `removeAllItems()`.  To clear the queue of all existing items, you would call `removeAllItems()`. The `removeItem()` method is used to remove a specific item instance from the queue.  This method can remove all instances of the specified item, ignoring the priority, remove a specific number of instances of an item ignoring priority, or remove items that match only if the priority matches:

```
// remove all instance of an item
pQueue.removeAt(myItem);

// remove only one instance of an item, starting from the top of the queue
pQueue.removeAt(myItem, 1);

// remove all instances of an item that match the priority of 3
pQueue.removeAt(myItem, int.MAX_VAlUE, 3);

// remove one instance of an item that matches the priority of 0
pQueue.removeAt(myItem, 1, 0);
```

When removing items by either specifying a number of instance and/or priority the method starts at the top of the queue and works downwards. So if you had three instances of `myItem` in the queue which all had different priorities and then you call `removeAt(myItem, 1)` only the first item (the priority 0 instance) would be removed.

If you need to remove an item at a specific position in the queue then you would use the `removeAt()` method.  If the position provided is not defined in the queue, then the method returns false and no error is thrown.  If the item position is valid then the method removes the item at the defined position, re-sorts the queue and returns true.  _Note:_ The PriorityQueue is 0 based just like an Array, so the first position is 0, second is 1, etc.:

```
// create the queue
var pQueue:PriorityQueue = new PriorityQueue();

// create some items
var itemOne:Object = {name: "itemOne"};
var itemTwo:Object = {name: "itemTwo"};
var itemThree:Object = {name: "itemThree"};

// add them to the queue
pQueue.addItem(itemOne); // defaulted to priority 5
pQueue.addItem(itemTwo); // defaulted to priority 5
pQueue.addItem(itemThree); // defaulted to priority 5

// remove the 1st item
pQueue.removeAt(0)

// return the items
trace(pQueue.next().name); //  Output: itemTwo
trace(pQueue.next().name); //  Output: itemThree
```

### Helper Methods ###
The PriorityQueue  has multiple helper methods/properties designed to make the queue easier to use. Just like the standard [Queue](QueueDataStructure.md), the PriorityQueue has the `hasItems` property which returns true if the queue has items or false if it is empty.  The PriorityQueue also has the `length` property that shows how many items are currently in the queue.  The `items` property is a clone Array version of the items in the queue.  This is a read-only property and attempting to set the value or change the values of the Array will not be reflected in the queue.

The last helper method on the PriorityQueue is the `peek()` method.  This method allows for a non-transfigative call to view the next item in the queue.  Unlike calling `next()`, `peek()` does not remove the item from the queue.

```
// create the queue
var pQueue:PriorityQueue = new PriorityQueue();

// create some items
var itemOne:Object = {name: "itemOne"};
var itemTwo:Object = {name: "itemTwo"};
var itemThree:Object = {name: "itemThree"};

// add them to the queue
pQueue.addItem(itemOne); // defaulted to priority 5
pQueue.addItem(itemTwo); // defaulted to priority 5
pQueue.addItem(itemThree); // defaulted to priority 5

// peek and then retrieve the items
trace(pQueue.peek().name); //  Output: itemOne
trace(pQueue.next().name); //  Output: itemOne
trace(pQueue.peek().name); //  Output: itemTwo
trace(pQueue.next().name); //  Output: itemTwo
trace(pQueue.peek().name); //  Output: itemThree
trace(pQueue.next().name); //  Output: itemThree
```

## Considerations ##

With any API/Data set there are always considerations that need to be made when using the technology.  Its always better to know about these potential issues before hand, rather then implementing the technology and then realizing it does not behave the way that was originally intended.

  * The PriorityQueue uses an Array to store the content internally.  This means that items in the PriorityQueue have a strong reference and will not be Garbage Collected (GC) if the queue is the only reference to the object instance.  Always remove items from a queue to enable GC.
  * When an item is called by `next()` or `peek()` the priority value is not returned or accessible.  The priority is solely used for ordering items internally within the PriorityQueue.
  * The `items` property is a clone of the internal Array and strips out all the priority value referencing from the data.