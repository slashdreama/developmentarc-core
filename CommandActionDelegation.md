# Introduction #

The Command and Action Delegation (CAD) system follows the Command Pattern which enables an invoker object to dispatch a message which is responsible for executing functionality encapsulated within an Action Class.  This system is made up of the ActionDelegate and a series of Abstract Classes which are responsible commands and actions that are executed by the ActionDelegate.

The CAD system is useful when common functionality within an application needs to be triggered by multiple sources.  An example of this would be a save data command.  The action of saving user data (to an Local Shared Object or desktop using AIR) can be triggered by many different scenarios. Users could save via a menu option in a menu bar, the right-click menu, pressing CMD+S, or even an auto-save feature.  The functionality of saving the data is always the same and would therefore be wrapped (encapsulated) within a Save Action.  The different triggers, say auto-save, would dispatch the Save Command which would trigger the Save Action functionality.

## Why CAD? ##
The DevelopmentArc<sup>TM</sup> Core CAD system is similar to the Cairngorm Command system, which is also built upon the Command Pattern used in other languages such as C++ and Java.  We have added CAD to Core for multiple reasons:

  1. **Framework Completeness** - We feel that the CAD system is a common requirement with application development and integrates seamlessly with the [Task Management System](TaskManagementSystem.md).  Without having the CAD system in Core, developers who are not using Cairngorm or another framework that supports the Command pattern would require the developer to implement either a custom solution or implement a new framework/micro-architecture to get this functionality.
  1. **MXML Definable** - The CAD Actions are designed to be registered either by adding Actions via ActionScript or by defining them via MXML.  Using MXML makes creating a single Action configuration MXML file very easy and does not require developers to look for an AS Class or file to define the Action/Command Relationship.
  1. **Easy access to Command Start / End** - One of the challenges with the Cairngorm Command system is there is not an easy way for developers to enable objects to listen for a start (dispatch) of a CommandEvent.  The Core CAD system is built upon the EventBroker which enables any object to subscribe to events dispatched through the broker.  This means that code can easily listen for the dispatch of a Command.  The executed Action can then either dispatch a complete event via the EventBroker when the command functionality is completed, or if the Task system is leveraged, delegate the complete dispatching to the executed Task.  We will talk more about Task integration later in this document.

# The Basics #
To understand how the CAD system works we will use the save user data example discussed in the Introduction.  To implement save using CAD, the first step is to create the Save Action.  This Class is our workhorse for the save system and is responsible for gathering user data and the storing it in the right location, such as an Local Shared Object or as a file on the desktop.

```
package com.developmentarc.demo {
	import com.developmentarc.framework.controllers.abstracts.AbstractAction;
	
	import flash.events.Event;

	public class SaveAction extends AbstractAction {
		public function SaveAction() {
			super();
		}
		
		// called when a command is dispatched, must be overridden
		override public function applyAction(command:Event):void {
			// do save functionality
			trace("File saved."); //output: File saved.
		}
		
	}
}
```

The SaveAction Class extends the DevelopmentArc<sup>TM</sup> Core AbstractAction and then overrides the `applyAction()` method.  When a Command is dispatched the `applyAction()` method of an Action is called by the ActionDelegate.  This method must be overridden or an error will be thrown by the AbstractAction. For this example, we will not write out real save logic, but just trace out the statement "File saved." when the use triggers the save command.

The next step is to create our Save Command.  Any Command we create must extend the Flash Event class since all commands are routed through the Core EventBroker.  An AbstractCommand has been provided to make this process of creating and dispatching commands easier.  In our example, we are simply extending the AbstractCommand and adding a static constant for type declaration.  In a real application we could add custom properties and other data to the command that is required.

```
package com.developmentarc.demo
{
	import com.developmentarc.framework.controllers.abstracts.AbstractCommand;

	public class SaveCommand extends AbstractCommand
	{
		static public const SAVE_COMMAND:String = "saveCommand";
		
		public function SaveCommand(type:String)
		{
			super(type);
		}
		
	}
}
```

## Using ActionScript To Define Action/Command Relationships ##

Now that we have an action and a command we need to link them together so that when the SaveCommand is dispatched, the SaveAction is executed.  To link an Action to a command, the Action class must define the commands it is listening for and then the Action must be added to ActionDelegate.

```
// this should be a property on your Main class
// or use the SingletonFactory / InstanceFactory
actionDelegate = new ActionDelegate();
			
// define the action and its command
var action:SaveAction = new SaveAction();
action.addCommand(SaveCommand.SAVE_COMMAND);

// add it to the delegate
actionDelegate.addAction(action);
```

In this example we create the ActionDelegate, create the save action, add the save command to the action and then add the action to the delegate.  The ActionDelegate then registers the Action to the Command via the EventBroker.  When the Command is dispatched the `applyAction()` method is then called.  To dispatch a command when a button is pressed we would do something like this:

```
public function handleMouseEvent(event:MouseEvent):void {
	switch(event.type) {
		case MouseEvent.CLICK:
			// create the command and dispatch it
			var command:SaveCommand = new SaveCommand(SaveCommand.SAVE_COMMAND);
			command.dispatch();
		break;
	}
}
```

When the user clicks on the button that is registered to `handleMouseEvent()` we create a new save command and then call dispatch.  This then dispatches the command to the EventBroker, which then calls the ActionDelegate which then calls `applyAction()`.

## Using MXML To Define Action/Command Relationships ##

In this version we will use MXML to define the relationship instead of ActionScript.  You do not have to use MXML to link the classes, but creating a single MXML command configuration makes encapsulation of the command definitions much easier.  For our example, we create a new MXML component called !commandConfig.mxml that has the ActionDelegate as the root type. One thing to note, when creating this MXML file, Flex Builder will not hint ActionDelegate as a component type.  We recommend just using any base type (Canvas) and then updating the xmlns to the ActionDelegate reference defined below.

```
<?xml version="1.0" encoding="utf-8"?>
<controllers:ActionDelegate 
	xmlns:controllers="com.developmentarc.framework.controllers.*"
	xmlns:demo="com.developmentarc.demo.*"
	xmlns:mx="http://www.adobe.com/2006/mxml" >
	
	<!-- IMPORTS -->
	<mx:Script>
		<![CDATA[
			import com.developmentarc.demo.SaveCommand;
		]]>
	</mx:Script>
	
	<!-- DEFINE ACTION / COMMAND RELATIONSHIP -->
	<controllers:actions>
		<mx:Array>
			<demo:SaveAction commands="{[SaveCommand.SAVE_COMMAND]}" />
		</mx:Array>
	</controllers:actions>
	
</controllers:ActionDelegate>
```

Unlike ActionScript, where we use the `addAction()` method, MXML requires that we set the `actions` property to an Array of actions.  We then set the commands property to an Array of Command types that we want the Action to listen for.  In this case our save action is just listening for the `SaveCommand.SAVE_COMMAND` type.

To link this into our application we do this:

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application
	xmlns:controllers="com.developmentarc.framework.controllers.*"
	xmlns:demo="com.developmentarc.demo.*" 
	xmlns:mx="http://www.adobe.com/2006/mxml" 
	layout="absolute" >
	
	<!-- IMPORTS -->
	<mx:Script>
		<![CDATA[
			import com.developmentarc.demo.SaveCommand;
		]]>
	</mx:Script>
	
	<!-- LINK COMMAND CONFIG -->
	<demo:commandConfig />
	
	<!-- SAVE ON CLICK -->
	<mx:Button label="save file" click="new SaveCommand(SaveCommand.SAVE_COMMAND).dispatch()" />

</mx:Application>
```

As you can see in this example, our Button creates a new SaveCommand and then dispatches it.

# Tracking Commands And Using Tasks #
As mentioned earlier, one of the benefits of the Development Core CAD system is that you can tap into the EventBroker to listen to Commands being dispatched.  An example of this would be updating UI elements when a load data command is dispatched.  You could have your UI listen for a LoadCommand and have it update itself:

```
// constructor
public function MyComponent() {
	super();
	
	// register for load commands
	EventBroker.subscribe(LoadCommand.LOAD_COMMAND, handleDataLoad);
	EventBroker.subscribe(LoadEvent.LOAD_COMPLETE, handleDataLoadComplete);
}

protected function handleDataLoad(command:LoadCommand):void {
	// show my loading state
}

protected function handleDataLoadComplete(event:LoadEvent):void {
	// show my default state
}
```

Another ability of the CAD is to tie into the DevelopmentArc<sup>TM</sup> Core Task system and let your Action delegate tasks based on UI states.  For example, when a user changes a Tab you may want to load tab specific data from the server:

```
override public function applyAction(command:Event) {
	var task:DataLoadTask;
	
	// our command has a tabState property
	switch(LoadCommand(command).tabState) {
		case "homepage":
			// create homepage task
			task = new DataLoadTask(DataLoadTask.HOMEPAGE);
		break;
		
		case "projects":
			// create projects task
			task = new DataLoadTask(DataLoadTask.PROJECTS);
		break;
	}
	
	// add the generated task
	taskController.addTask(task);
}
```

To wrap up our UI loading example, our Task would dispatch a `LoadEvent.LOAD_COMPLETE` through the EventBroker when the Task was done loading the data.  This would then have the UI described above, set its state back to the default look.