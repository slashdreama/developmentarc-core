# Introduction #
The SingletonFactory can be used to turn any object in your application into a singleton. The SingletonFactory is similar to the InstanceFactory but provides single instances on a Application level, exactly like a Singleton object would behave.  A singleton is a pattern that restricts the instantiation of an object to one instance.  Using this factory only one object will be created per class type.  However, outside of the factory, there is no restriction or control.  The SingletonFactory is itself a singleton (via a SingletonLock) but encapsulates the single instance inside of static methods. That way developers can use the SingletonFactory as if it was a static utility class.   Below we will detail the available APIs for the class.


# Creating an Singleton Instance #
To create a singleton instance, pass a class type into the
getSingletonInstance method. If the instance has not already been created, the factory will create the instance and store it in a key/value table, otherwise the instance will be looked up and returned.  A good use case for using the SingletonFactory is the model locator pattern. In many applications, there is a need to an application wide models. In A an example is a User class. We could either make the model class a singleton via a [ActionScript Singleton pattern](http://blog.vivisectingmedia.com/2008/06/the-extendable-singleton-pattern), or utilize the SingletonFactory out-of-box, without the extra code to make a class a singleton.

## Our Model Class ##
Here's the model class we will use throughout this documentation.
```
   public class UserModel {
      public var id:uint;
      public var firstName:String;
      public var lastName:String 
   }   
```

## Creating a Singleton ##

```
   // The instance is created and stored in the factory
   var user:UserModel = SingletonFactory.getSingletonInstance(UserModel);
   user.id = 1;
   // The stored instance is retrieved and passed back.
   var user2:UserModel = SingletonFactory.getSingletonInstance(UserModel);

   // This will evaluate true
   if(user.id == user2.id) {
      Alert.show("Users are identical")
   }
```

# Remove an Instance(s) #
The SingletonFactory provides two method to clear instances from the factory. One removes a specific instance (clearSingletonInstance) and another removes all instances in the factory (clearAllSingletonInstances).

## Single Instance ##
A single instance can be removed from the factory by utilizing the clearSingletonInstance method. This method is useful when you are resetting an application. In the case of our user, if a user logs off and logs on with a different user, we would want to make sure we have removed the old user from the system before setting a new one.

```
    // Get current user
    var currentUser:UserModel = SingletonFactory.getSingletonInstance(UserModel);
    // Remove current user
    SingletonFactory.clearSingletonInstance(UserModel);

    // Create new user
    newUser:UserModel = SingletonFactory.getSingletonInstance(UserModel);

    // This will evaluate false
   if(currentUser != newUser) {
      Alert.show("Users are not the same instance")
   }
    
```

## All Instances ##
If an application needs to fully reset and all singletons are to be removed, you can use the clearAllSingletonInstances method to do so.

```
    // Get current user
    var currentUser:UserModel = SingletonFactory.getSingletonInstance(UserModel);
    // Remove all models, including the UserModel
    SingletonFactory.clearAllSingletonInstances();

    // Create new user
    newUser:UserModel = SingletonFactory.getSingletonInstance(UserModel);

    // This will still evaluate false
   if(currentUser != newUser) {
      Alert.show("Users are not the same instance")
   }

```
# Creating A Model Locator Example #
In our basic example we talk about how we can use the SingletonFactory to create model instances.  To take this example one step further, we will create a ModelLocator class that wraps the SingletonFactory as our generation system.  First, we want to have an Interface that defines our model examples:

```
public interface IModel
{
	function set id(value:uint):void
	function get id():uint;
}
```

Next, we now have our UserModel extend the IModel:

```
public class UserModel implements IModel {
	
	public var firstName:String;
	public var lastName:String;
	
	private var __id:uint;
	
	public function set id(value:uint):void {
		__id = value;
	}
	
	public function get id():uint {
		return __id;
	}
	
}
```

Now, we can build our ModelLocator that returns casts our return values as IModels:

```
public class ModelLocator
{
	static public function getModel(model:Class):IModel {
		var inst:* = SingletonFactory.getSingletonInstance(model);
		if(!inst is IModel) throw new Error("Not an IModel");
		return IModel(inst);
	}

}
```

This is just one simple example of how the SingletonFactory can be leveraged inside other Classes.