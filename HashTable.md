# Introduction #

The HashTable is a ActionScript 3 based data structure used to store data in a key/value pair allowing for the ability to retrieve the data by providing the key bound to the specific object.  Unlike using an Object with a name/value pair or an associative Array the HashTable has easy helper methods to verify an existence of a specific value or key, the ability to return the values or the keys as an Array within the table, and other helpful methods such as `containsItem()` and `containsKey()`.


# Details #

The HashTable was created to support the ability to quickly store items in a collection using a key object as a reference to the stored value, similarly to the Dictionary or Object.  Yet, unlike an Object or Dictionary the HashTable has accessors that enable developers to access the HastTable's content as an Array.  This is similar to Flex's ArrayCollection, yet unlike the ArrayCollection, the focus was on creating a much easier and less verbose syntax for accessing items.

Performance was another focus of the initial design of the HashTable.  The ArrayCollection is a great collection structure, but it has a lot of overhead to enable data pagination and hooks into the RemoteObject structure to create easier CRUD interactions with servers.

## The Basics ##

The Basic usecase for the HashTable is the ability to store any kind of data using any kind of data (scalar, object, Class) as a key.  This allows for easy access to the content, for example:

```
// create a key (person) and item (friends)
var person:Object = {name: "James"};
var friends:Array = [{name: "Eno"}, {name: "Aaron"}, {name: "Doug"}, {name: "Dave"}];
 
// create the table
var hash:HashTable = new HashTable();
hash.addItem(person, friends);
 
...
 
// get my friends
var myFriends:Array = hash.getItem(person) as Array;
```

The simple object `person` is used to as the key for the HashTable and the Array `friends` is stored as the value.  Once the item has been stored it can the be retrieved by simply passing in the key `person` to return the Array.

As mentioned earlier, the HashTable has the ability to return its data as an Array so that it can be looped over and processed as expected with any Array:

```
// get all the people and loop on them
var people:Array = hash.getAllKeys();
var len:int = people.length();
for(var i:uint = 0; i < len; i++)
{
	var friends:Array = hash.getItem(people[i]) as Array;
	...
}
```

There are other helpful methods for accessing items, verifying that the HashTable has content, cleaning up the HashTable, etc:

```
// how many key/items are in the HashTable
var numberOfItems:int = hash.length;
 
// do we have any items
if(!hash.isEmpty)
{
	// do something
	...
}
 
// is the key or the item in the table?
if(hash.containsKey(person) || hash.containsItem(friends))
{
	// do something
	...
}
 
// we can also remove key pairs
hash.remove(person);
 
// or clear the entire table
hash.removeAll();
```

## Considerations ##

With any API/Data set there are always considerations that need to be made when using the technology.  Its always better to know about these potential issues before hand, rather then implementing the technology and then realizing it does not behave the way that was originally intended.

  * The HashTable uses an Array under the hood so this means items are strong referenced. Make sure to remove the items from the HashTable before you decide you no longer need the items in you application and want the Garbage Collection to clean them up.
  * When using the `getAllKeys()` or `getAllItems()` you are being handed back a clone of the internal Array. If you want to change the value in the HashTable you will need to overwrite them by updating the HashTable.
  * You can have the same object multiple times in the HashTable if it is an item, but only one instance as a key. This means that if you have the object `person` as the key to item `friends`, and then try to `addItem(person, friendsTwo)` then `friends` will be replaced with `friendsTwo` within the table. This is silent change and is expected. Key’s must be unique otherwise to original item value is overwritten.