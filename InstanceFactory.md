# Introduction #
The InstanceFactory provides a means to creating a single instance of a class. The goal is to provide a way for different areas of an application to create and hold onto single instances of objects, without the overhead of managing their creation and retrieval.  The InstanceFactory is similar to the SingletonFactory in that is creates a class one time and holds on to that class until it is removed or the end of the application's life.  The available API is identical to the SingletonFactory.  The only different between the two factories is, the InstanceFactory must be instantiated where as the SingletonFactory is used as static class and methods.  Below we will demonstrate if of the available methods.


# Creating an Singleton Instance #
To create a singleton instance, pass a class type into the
getSingletonInstance method. If the instance has not already been created, the factory will create the instance and store it in a key/value table, otherwise the instance will be looked up and returned. In the example below, we have an application which keeps state in mutliple sections of the application. These states, are not shared across the different sections so storing them in application scope is not required, therefore we will use the InstanceFactory instead.

## Our Model Class ##
Here's the model class we will use throughout this documentation.
```
   public class SectionModel {
      public var id:uint;
      public var isShowing:Boolean;
      public var bizData:BusinessDO; 
   }   
```


# Create an Instance of the Factory #
Unlike the SingletonFactory you must create an instance of the InstanceFactory before you can begin using it.

```
  var instanceFactory:InstanceFactory = new InstanceFactory();
```

## Creating a Singleton ##

```
   // Use our new !InstanceFactory and create an instance of the SectionModel and store it
   // in the factory
   var sectionModel:SectionModel = instanceFactory.getSingletonInstance(SectionModel);
   sectionModel.isShowing = true;
   // Retrieve the stored instance.
   var sectionModel2:SectionModel = instanceFactory.getSingletonInstance(SectionModel);

   // This will evaluate true
   if(sectionModel.isShowing == sectionModel2.isShowing) {
      Alert.show("SectionModels are identical")
   }
```

# Remove an Instance(s) #
The InstanceFactory provides two method to clear instances from the factory. One removes a specific instance (clearSingletonInstance) and another removes all instances in the factory (clearAllSingletonInstances).

## Single Instance ##
A single instance can be removed from the factory by utilizing the clearSingletonInstance method. This method is useful when you want to clean up dead instances when a section of your application. By removing your instance before the section is removed (maybe it a module that is unloaded), you can clean up all instances to ensure all references have been removed so GC can occur.

```
    // Remove current section model
    instanceFactory.clearSingletonInstance(SectionModel);
    // Removes the module
    moduleLoader.unload();
```

## All Instances ##
In most cases however,when you are unloading a module, you would want to make sure all instances are cleared from the InstanceFactory, therefor you would use clearAllSingletonInstances to remove all instances.

```
    // Remove all instances
    instanceFactory.clearAllSingletonInstances();
    // Removes the module
    moduleLoader.unload();
```