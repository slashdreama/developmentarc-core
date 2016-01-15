# Introduction #

The goal of the Queue system is to allow any type of mixed data, from scalars to complex objects, to be stored in a specified sequential order and then retrieved in that order when required. The Queue system is made up of two different Data Structures, the standard Queue and the PriorityQueue.  The standard Queue stores data linearly in the order added and the returned based on either First in First out (FIFO) or Last in First Out (LIFO) order.  The PriorityQueue stores data in order of priority, which is assigned at the time of addition to the queue.  This means that higher priority items are always returned before lower priority items.  The queues are relatively simple data structures that enable other functionality within DevelopmentArc<sup>TM</sup> Core, such as the Task System yet they can also be leveraged by any Flash Platform application that uses DevelopmentArc<sup>TM</sup> Core.

# The Standard Queue #

The standard Queue is a First in First out (FIFO) or Last in First Out (LIFO) ordered collection that uses an internal Array to store the content of the item. Items are stored in the order they are added and the returned based on the sort order direction for the queue.  The Queue offers the ability to both reorder the queue by removing items and then adding items at specific places and has other convenience methods to verify the number of items in the queue or if queue contains any items.

[Read more about the standard Queue data structure](QueueDataStructure.md)

# The PriorityQueue #

The PriorityQueue is a sort ordered queue based on a specified priority assigned to the item when it is added to the queue.  When an item is added, the queue handles looking at existing items, evaluates their priority value and then re-sorts the queue based on the give priorities of the new item and the existing items.  Higher priority items are always kept at the top of the queue and lower priority items are kept at the end of the queue.  Unlike the standard Queue, the PriorityQueue does not have a direction value, all sorting and retrieval are based on the assigned priority value.

[Read more about the !PriorityQueue data structure](PriorityQueue.md)