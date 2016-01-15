# Introduction #

By default, implementing a local connection requires multiple steps of registering events, proper wrapping of calls in try/catch blocks, and passed sealed Class instances are stripped of their type information when sent over the wire rendering them into generic objects.  The LocalConnection Manager is a utility Class that provides a quick way to establish a Flash Player Local Connection and retain type information when passing sealed Class instances over the wire.

# The Basics #

When establishing and using a Flash Local Connection for communication, two unique identification values need to be defined: the connection name and the target name. Without these values no application can communicate with another.  For example, we have two SWFs that want to connect and communicate with each other: SWF A and SWF B.  First, both SWFs need to establish a unique connection name for themselves.  This connection name is a unique id that acts like a "home address" for the SWF.  Any one that wants to send a message to this SWF must know the connection name.

For our example, SWF A is going to assign itself an address (or connection name) as "SWF\_A\_ADDRESS" and SWF B is going to assign itself an address (connection name) as "SWF\_B\_ADDRESS".  Now, for SWF A to talk to SWF B it needs to know SWF B's address is "SWF\_B\_ADDRESS", this is the target name for SWF A.  SWF B needs to know the address of SWF A, so "SWF\_A\_ADDRESS" is the target name for SWF B. As you can probably tell, for this to work both SWFs need to know the connection name of the other SWF before it can communicate, so these values need to be established when you create the SWFs.

The other requirement of the Local Connection is to have a public method available on the receiving SWF that the calling SWF must know about.  In our example both SWF A and SWF B would have a public method called `receiveMessage()`.  When one of the SWFs wishes to send a message to the other, the SWF passes in the target address, the method to call and any parameters required buy the target method.  Let's take a look at a simple example:

**SWF A Example Code**
```
public var swfAConnection:LocalConnectionManager;

public function init():void {
	// set up our connection
	swfAConnection = new LocalConnectionManager(this, "SWF_A_ADDRESS");
	
	// register events
	swfAConnection.addEventListener(LocalConnectionEvent.CONNECTION_ERROR, handleLocalConnectionEvent);
	swfAConnection.addEventListener(LocalConnectionEvent.SENT_MESSAGE_ERROR, handleLocalConnectionEvent);
	swfAConnection.addEventListener(LocalConnectionEvent.STATUS_MESSAGE, handleLocalConnectionEvent);
}

public function sendMessage():void {
	// send a message to SWF B
	swfAConnection.sendMessage("SWF_B_ADDRESS", "recieveMessage", "SWF A calling SWF B!");
}

public function receiveMessage(message:String):void {
	// trace out the message if we receive one
	trace(message);
}
```

**SWF B Example Code**
```
public var swfBConnection:LocalConnectionManager;

public function init():void {
	// set up our connection
	swfBConnection = new LocalConnectionManager(this, "SWF_B_ADDRESS");
	
	// register events
	swfBConnection.addEventListener(LocalConnectionEvent.CONNECTION_ERROR, handleLocalConnectionEvent);
	swfBConnection.addEventListener(LocalConnectionEvent.SENT_MESSAGE_ERROR, handleLocalConnectionEvent);
	swfBConnection.addEventListener(LocalConnectionEvent.STATUS_MESSAGE, handleLocalConnectionEvent);
}

public function sendMessage():void {
	// send a message to SWF A
	swfBConnection.sendMessage("SWF_A_ADDRESS", "recieveMessage", "SWF B calling SWF A!");
}

public function receiveMessage(message:String):void {
	// trace out the message if we receive one
	trace(message);
}
```

Looking at the code you can see that the only real difference between the two SWFs is the connection name they use when they create a new `!LocalConnectionManager` instance and the target name they use when the SWF calls `sendMessage()`.  By defining a unique address the connection manager can now help broadcast and receive messages via the local connection.

One thing to note about the Local Connection, is that only one SWF can connect using a specific connection name.  For example, if we have two instances of SWF B running at the same time, whichever instance was the first to connect will be able receive messages on that channel.  The second instance to connect will receive no messages from the broadcaster.

## Retaining Class Type ##

One of the powerful things about the Local Connection is that the data serialization/de-serializaton syntax is based on the AMF protocol.  These means that if both SWFs have the same Class type reference, the class object instances can be passed back and forth retaining their type.  The process of setting up AMF to do this is tedious so the LocalConnectionManager takes care of this process for you.  As long as both applications have the same data type then the Class instance will be serialized and de-serialized correctly.

For example, we have a User object that we want to pass back and forth between SWF A and SWF B:

```
package com.developmentarc.exmaple {
	public class User {
		public var firstName:String;
		public var lastName:String;
		public var id:uint;
	}
}
```

Both SWF A and SWF B have references to this class and use it.  In this case SWF A will be sending SWF B a user instance:

**SWF A Example Code**
```
import com.developmentarc.exmaple.User;

public function sendUser():void {
	// send a user to SWF B
	var userInst:User = new User();
	userInst.firstName = "Homer";
	userInst.lastName = "Simpson";
	userInst.id = 3322;
	swfAConnection.sendMessage("SWF_B_ADDRESS", "recieveUser", userInst);
}
```

**SWF B Example Code**
```
import com.developmentarc.exmaple.User;

public function recieveUser(user:User):void {
	// do something with the user
	trace(user.firstName, user.lastName) //output: Homer Simpson
}
```

If, for some reason, SWF B did not have the matching User object the LocalConnectionManager is smart enough to first check to see if the type exists, if it does not then SWF B will inform SWF A via a LocalConnectionManager Error Event that it did not have the proper class reference.

# Considerations #

With any API/Data set there are always considerations that need to be made when using the technology.  Its always better to know about these potential issues before hand, rather then implementing the technology and then realizing it does not behave the way that was originally intended.

  * To use Class type management, all applications communicating must use the LocalConnectionManager to handle the Class registration required by the AMF protocol.
  * It is recommended that when you implement the LocalConnectionManager that you define your communication methods and LCM instance in a dedicated Class.  By doing this, only the public methods of the dedicated class are exposed, thus limiting what can/cannot be accessed via the local connection.
  * When passing data via the LocalConnectionManager, use dedicated Data Objects that can easily be serialized and de-serialized.  If the objects constructor requires properties this can cause creation issues when the new object is created.  For more information on using Transient Metadata and passing data across the AMF protocol review [Darron Schall's detailed post](http://www.darronschall.com/weblog/2007/08/on-transient-objectutilcopy-and-casting.cfm).
  * AIR and Flash movies can communicate using Local Connection.