# Introduction #

The EventBroker is a publisher/subscriber utility class used to decouple event communication between multiple classes in an application.  Publisher classes can broadcast events without direct knowledge of subscriber classes. When an event is broadcasted, the EventBroker is responsible to communicating with each subscriber class, calling the callback method on that class.

The EventBroker class itself is implemented as a Singleton Facade, with four public static methods that wrap the Singleton instance. Each method and their usage is broken down below.


# Event #
Events passed through the system must extend the Event class.  Throughout our examples below we will leverage an event class defined as CustomEvent.  If custom data is not required, a class can simple leverage the Event class passing in a custom event type.

```
  public class CustomEvent extends Event {
      public static var EVENT_TYPE:String = "CUSTOM_EVENT";
      
      // Custom data
      public var id:uint;
  }

```

# Publish #
A publisher class will use the broadcast method to dispatch events through the event sub-system. The class will send the event to the EventBroker without any knowledge of those classes subscribing to the event.

```
public class PublisherComponent extends UIComponent {

  public function sendMessage():void {
     var event:CustomEvent = new CustomEvent(CustomEvent.EVENT_TYPE);
     event.id = 1234;

     // Broadcast event to all subscribers
     EventBroker.broadcast(event);

  }
}
```

# Subscribe #
To be notified an event has occurred a class must subscribe to an event type and provide a callback method which will be invoked when the defined event type is published.  Upon the event being broadcasted, the EventBroker, will invoke the defined callback method on each subscriber for that particular event.

Architecture Note: When a component subscribes to multiple event types, define two methods, one to subscribe all events and one to unsubscribe. By creating a common pattern, developers can move from class to class and know where all subscriptions live.

```

public class SubscriberComponent extends UIComponent {

   override public function initialize():void {
     addSubscriptions();
   }
   
   protected function addSubscriptions():void {
     EventBroker.subscribe(CustomEvent.EVENT_TYPE, handleBroadcastedEvent);
   }

   protected function handleBroadcastedEvent(event:CustomEvent) {
     trace("Event id is " + event.id);
   }
}

```
# UnSubscribe #
When a component is removed from the application, all subscriptions should be removed.  The unsubscribe method takes the same a parameters as the subscribe method, an event type and the component's callback method.


```

public class SubscriberComponnet extends UIComponent {
    // Method cleans up internal class references, that possibly could stop GC from occuring when method is removed.
    public function destroy():void  {
      removeSubscription();
    }

    protected function removeSubscriptions():void {
      EventBroker.unsubscribe(CustomEvent.EVENT_TYPE, handleBroadcastedEvent);       
    }
}
```

# Clear All Subscriptions #
Method removes all subscriptions in the EventBroker sub-system.  This method should be used with caution because it will remove all linkages in the application without direct knowledge of what is actually being removed.


```
   public class CustomApplication extends Application {

     private method removeAllSubscriptions():void {
        // Remove all subscriptions in the application
        EventBroker.clearAllSubscriptions();
     }
   }

```