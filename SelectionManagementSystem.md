# Introduction #

The Selection Management system provides a way to make any object selectable and part of a selectable group. By implementing a simple interface !ISelectable which exposes a single property "selected", a developer can make any object in its code base a selectable item.  By adding an instance of the ISelectable item to a selectable group, we can create a set of objects that behavior together like one would expect of a RadioButtonGroup and a RadioButton. When an item is selected, all other items in the group are unselected.  There are two ways to use the Selection Management system to control groups of selectable items.  The first to leverage the system's controller class SelectionController,which provides developer the most control in selecting and unselecting items. However, this approach requires more custom code that might necessarily be needed. To provide a more out of box solution, a SelectionGroup class is available for developer to leverage to encapsulate the common code a typical group would use to select and unselect items.   Below we will explore how to create a !ISelectable item and how to utilize the both grouping systems.

# Creating a Selectable Item #

To create a selectable item, implement the ISelectable interface and define a get and set method for the selected attribute. The set method should analyze the Boolean value provided and display the correct state of the object based on the value.  If the value is true, the object should show the selected state, otherwise unselected.

In the example below, we will look at the value and set the classname based on its value.  The current selected value is saved inside of a private variable "selected".

```
public class SelectionItem extends UIComponent implements ISelectable
{
  private var __selected:Boolean;
		
  public function get selected():Boolean
  {
     return __selected;
  }
  
  public function set selected(value:Boolean):void
  {
     __selected = value;
			
    className = (__selected) ? "selectedItem" : "unSelectedItem";
  }
}
```
# Using The SelectionController #
The SelectionController is the main class of the system.  This class is a Singleton and provides static method to encapsulate the singleton instance.  Developers have a choice to interact directly with this class or use the SelectionGroup to bypass direct interaction. with the controller.  Developers who want full control over selecting and unselecting items should use the controller directly.  An example use case is for a custom tab based system where each tab object is part of a selection group and upon selection, the tab should not select until data is returned from the server. In order to execute this behavior, the invoking class would have to listen to both the selection of the item and an event from the service layer indicating data has been returned from the server.  Below we will learn how to create a selection group from the controller, add/remove items, and how to select an item and deselect all items in the group.


## Creating a Group ##
The selection controller generates a group id via the generateNewId method.  This id is passed into all method to access the group and perform various operations such as adding and removing items.

```
_groupId = SelectionController.generateNewId();
```
## Adding items ##
Items are added to a group one by one via the addItem method.

```
var selectionItem:SelectionItem = new SelectionItem();
SelectionController.addItem(selectionItem, _groupId);
```
## Removing an single item ##
Items can be removed one by one using removeItem.
```
SelectionController.removeItem(selectionItem,_groupId);
```
## Removing all items from a group ##
If you have more than one item in a group and want to remove all items in that group use removeAllItems.
```
SelectionController.removeAllItems(_groupId);
```
## Selecting an item ##
To select an item you must call the selectItem method on the controller. The controller will take responsibility for setting the selected property on each item in the group.  The item passed in will get a value of true, all others will be set to false. Remember it is up to the ISelectionItem implementation to actually change the state of the object.  The controller simple sets boolean values on each object in the group.
```
SelectionController.selectItem(selectionItem);
```

## Get selected item ##
If you need to identify and gain reference to the currently selected items (there can be more than one if you set it up to do so) you can use getSelected.
```
var items:Array = SelectionController.getSelected(_groupId);
```

## Deselecting all items ##
If you want to reset the group and deselect all items and not have to write extra code to identify the current selected item and then use a remove for each item, there is a handy method that can do it for you in one line, deselectAll.
```
SelectionController.deselectAll(_groupId);
```

## Get Item Group ##
If for some reason you dont have access to the group id, but do have access to an ISelectable item, you can figure out the group id by using getItemGroup. Simply pass in the ISelectable item and the method will return the group id. If the ISelectable item is not part of a group, the method will return -1.
```
var groupId:int = SelectionController.getItemGroup(selectionItem);
```

## Get All Items in a Group ##
With a group id you can retrieve an array containing all items in the group. Use getAllItemsInGroup to perform this functionality.
```
var items:Array = SelectionController.getAllItemsInGroup(_groupId);
```


# Using The SelectionGroup #
The SelectionController provides low-level control of a group of selectable items.  However, in most cases, this extra control is not needed. Also, by using the SelectionController, the ability to declare add items via MXML into a group is not possible. This is where a SelectionGroup comes in. To use a SelectionGroup a developer will define an instance of the group and assign items to that group. The group will encapsulate the interaction with the SelectionController (the controller still does the work).  The group allows developers define items into a group and be done with it. This means, you wont have to write extra code to select and unselect items.  The group by default will listen to the click event of each item in the group and will select/deselect items based on the event. A SelectionGroup allows developers to define a set of events the group should listen to. These events can be custom, Flex, or Flash API events.  Below we will explore how to create a SelectionGroup via MXML and ActionScript and how to assign items to the new group.  Also, we will show you how to employ custom events.
Remember, the goal of the SelectionGroup is to limit the amount of code a developer has to write in order to select and deselect items. The group does all this work for you, so you can focus on business logic and not generic behavior.

Note, that the SelectionGroup will listen to events on the ISelectable items, so the class must implement or extend from a class that defines !IEventDispatcher.


## Creating a SelectionGroup ##
You can create a group either by MXML of ActionScript.
### MXML ###
```
<controllers:SelectionGroup id="selectionGroup"/>
```
### ActionScript ###
```
var selectionGroup:SelectionGroup = new SelectionGroup();
```

## Adding Items ##
When adding items to a group, it must be an Array. Each time the items property on SelectionGroup is set, the current set of items will be removed from the group and the new set will be applied.  If the group is created in MXML, the items property can be set during declaration. In ActionScript the items must be declared and assigned to an array before they are added to the group.
### MXML ###
```
<controllers:SelectionGroup id="selectionGroup" items="{[item1,item2]}" />
<mx:HBox horizontalGap="30">
   <local:SelectableItem id="item1" width="10" height="10"/>
   <local:SelectableItem id="item2" width="10" height="10"/>
</mx:HBox>
```
### ActionScript ###
```
var item1:SelectionItem = new SelectionItem();
var item2:SelectionItem = new SelectionItem();

var items:Array = [item1,item2]

var selectionGroup:SelectionGroup = new SelectionGroup();

selectionGroup.items = items;
```

## Adding Custom Events ##
With the SelectionGroup you can define a set of events that the group will listen for on each item in the group.  The set of events is defined as a comma exasperated list of strings, that define the event type.  The group will handle each event and select the item that dispatched the event, while deselecting all others.  The events can be custom events defined by you, or out-of-the-box events in the Flex or Flash API.  If no events are defined in the group, the default event will be MouseEvent.CLICK.

### MXML ###
In the code below, we define one custom event and one event from the Flash API.The group will select and deselect when either event is dispatched.

```
<controllers:SelectionGroup id="selectionGroup" items="{[item1,item2]}" events="{MouseEvent.CLICK}, {CustomEvent.FIRE}"/>
<mx:HBox horizontalGap="30">
   <local:SelectableItem id="item1" width="10" height="10"/>
   <local:SelectableItem id="item2" width="10" height="10"/>
</mx:HBox>
```

### ActionScript ###
A thing to note, that become apparent in AcionScript, the set of events must be defined before the items are selected. This is because, when items are added to a group, the events are added as event listeners. If the events are not defined, then the default event MouseEvent.CLICK will be assigned.

```
var item1:SelectionItem = new SelectionItem();
var item2:SelectionItem = new SelectionItem();

var items:Array = [item1,item2]

var selectionGroup:SelectionGroup = new SelectionGroup();

selectionGroup.events = [MouseEvent.CLICK, CustomEvent.FIRE].join(",");
selectionGroup.items = items;
```